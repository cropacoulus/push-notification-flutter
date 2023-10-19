import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_notifications/main.dart';
import 'package:push_notifications/model/helper.dart';
import 'package:push_notifications/model/message.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        try {
          if (payload != null) {
            RemoteMessage args = remoteMessageFromJson(payload);
            await Navigator.pushReplacementNamed(
              context,
              '${args.data["route"]}',
              arguments: MessageArguments(args),
            );
          }
        } catch (e) {
          print(e.toString());
          print('Error parsing payload: $payload');
        }
      },
    );
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      String testingJsonString = remoteMessageToJson(message);

      if (notification != null && android != null) {
        await _notificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          notificationDetails,
          payload: testingJsonString,
        );
      }
    } on Exception catch (e) {
      print(e);
      print('error showing notification');
    }
  }
}
