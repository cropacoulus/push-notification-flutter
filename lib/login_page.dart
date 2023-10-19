import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:push_notifications/main.dart';
import 'package:push_notifications/model/User.dart';
import 'package:push_notifications/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // UserModel? _user;

  @override
  void initState() {
    super.initState();
    
    checkLogin();
  }

  Future checkLogin() async {
    var check = await Hive.openBox('users');
    print(check.get('_id'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/register');
              },
              child: Text('REGISTER'),
            ),
            ElevatedButton(
              onPressed: () {
                AuthServices.signInWithApi(
                  _emailController.text,
                  _passwordController.text,
                ).then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainPage(),
                      ),
                    ));
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
