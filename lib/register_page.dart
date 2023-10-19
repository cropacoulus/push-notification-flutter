import 'package:flutter/material.dart';
import 'package:push_notifications/main.dart';
import 'package:push_notifications/model/User.dart';
import 'package:push_notifications/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

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
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'UserName',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                AuthServices.signUpWithApi(
                  _emailController.text,
                  _passwordController.text,
                  _nameController.text,
                ).then((value) async {
                  Navigator.pushNamed(context, '/');
                });
              },
              child: Text('register'),
            ),
          ],
        ),
      ),
    );
  }
}
