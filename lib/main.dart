import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_notifications/berita_page.dart';
import 'package:push_notifications/firebase_options.dart';
import 'package:push_notifications/green_page.dart';
import 'package:push_notifications/hive/config.dart';
import 'package:push_notifications/login_page.dart';
import 'package:push_notifications/register_page.dart';
import 'package:push_notifications/model/User.dart';
import 'package:push_notifications/model/message.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:push_notifications/notification_list.dart';
import 'package:push_notifications/red_page.dart';
import 'package:push_notifications/services/auth_service.dart';
import 'package:push_notifications/services/local_notifications_service.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  if (message.notification != null) {
    print(message.notification!.title);
    print(message.notification!.body);
  }
  print("Handling a background message: ${message.messageId}");
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

late Box box;

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // if not running on Android, don't create a notification channel
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      //   alert: true,
      //   badge: true,
      //   sound: true,
      // );
    }
    await Hive.initFlutter();
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('users');
    Hive.registerAdapter(UserModelAdapter());

    runApp(const MyApp());
  } catch (e) {
    print(e.toString());
    print('Error initializing Firebase');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // initialRoute: '/login',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/main': (context) => const MainPage(),
        '/green': (context) => const GreenPage(),
        '/red': (context) => const RedPage(),
        '/berita': (context) => const BeritaPage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();

  String _token = '';

  UserModel? _user = box.get('users');

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getToken();
    setPublic();
    setupToken();

    LocalNotificationService.initialize(context);

    //gives you the message on which user taps
    //and it opened the app from terminated state
    _messaging.getInitialMessage().then((message) {
      if (message != null) {
        Navigator.pushNamed(
          context,
          message.data['route'],
          arguments: MessageArguments(message),
        );

        print(message.data['route']);
      }
    });

    //foreground notification
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }
      setState(() {
        _dataController.text = message.data.toString();
      });
      LocalNotificationService.display(message);
    });

    //when app is in background but opened and user taps on notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data['route'];

      Navigator.pushNamed(
        context,
        message.data['route'],
        arguments: MessageArguments(message),
      );

      print(message.data['route']);
    });

    super.initState();
  }

  Future<void> setupToken() async {
    String? token = await _messaging.getToken();

    if (token != null) {
      await saveTokenToDatabase(token);
    }

    _messaging.onTokenRefresh.listen(saveTokenToDatabase);
  }

  Future<void> saveTokenToDatabase(String token) async {
    if (_user != null) {
      String? userId = _user!.id;
      String? name = _user!.name;
      print(name);

      final response = await Dio().put(
        'http://192.168.77.29:3000/api/$userId',
        data: {'tokenFcm': token},
      );
      if (response.statusCode == 200) {
        print('success put data $response');
      }
    }

    print('user $_user!');
  }

  getToken() async {
    String? token = await _messaging.getToken();
    print(token);
    _tokenController.text = token!;
  }

  setPublic() async {
    print('set public');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notify'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationList(),
                ),
              );
            },
            icon: const Icon(Icons.notifications),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Subscribe voucher'),
                value: 'subscribe_voucher',
                onTap: () async {
                  await _messaging.subscribeToTopic('voucher');
                  print('subscribed to voucher');
                },
              ),
              PopupMenuItem(
                child: Text('Unsubscribe voucher'),
                value: 'unsubscribe_voucher',
                onTap: () async {
                  await _messaging.unsubscribeFromTopic('voucher');
                  print('unsubscribed from voucher');
                },
              ),
              PopupMenuItem(
                child: Text('Subscribe kategory'),
                value: 'subscribe_category',
                onTap: () async {
                  await _messaging.subscribeToTopic('category');
                  print('subscribed to category');
                },
              ),
              PopupMenuItem(
                child: Text('UnSubscribe kategory'),
                value: 'unsubscribe_category',
                onTap: () async {
                  await _messaging.unsubscribeFromTopic('category');
                  print('unsubscribed to category');
                },
              ),
              PopupMenuItem(
                child: Text('Get Token'),
                value: 'getToken',
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                readOnly: true,
                scrollPhysics: ScrollPhysics(parent: BouncingScrollPhysics()),
                decoration: const InputDecoration(
                  labelText: 'token',
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  border: InputBorder.none,
                ),
                controller: _tokenController,
                maxLines: 100 ~/ 20,
              ),
              TextFormField(
                readOnly: true,
                scrollPhysics: ScrollPhysics(parent: BouncingScrollPhysics()),
                decoration: const InputDecoration(
                  labelText: 'data',
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  border: InputBorder.none,
                ),
                controller: _dataController,
                maxLines: 100 ~/ 20,
              ),
            ],
          ),
        ),
      ),
    );
    // return Scaffold();
  }
}
