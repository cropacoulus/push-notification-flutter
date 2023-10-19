import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:push_notifications/hive/config.dart';
import 'package:push_notifications/model/User.dart';

class AuthServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> signInAnonymous() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;

      return user!;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<void> signInWithApi(String email, String password) async {
    try {
      var response = await Dio().post('http://192.168.77.29:3000/api/signin', data: {
        'email': email,
        'password': password,
        // 'name': name,
        // 'tokenFcm': token,
      });

      if (response.statusCode == 200) {
        print(response.data['user']);
        // print(users.toMap());
        var users = await Hive.openBox('users');
        var res = response.data['user'];
        // print(users.toMap());

        return users.put('users', UserModel(res['_id'], res['email'], res['password'], res['name']));
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<UserModel?> signUpWithApi(String email, String password, String name) async {
    try {
      var response = await Dio().post('http://192.168.77.29:3000/api/signup', data: {
        'email': email,
        'password': password,
        'name': name,
        // 'tokenFcm': token,
      });

      if (response.statusCode == 201) {
        return UserModel.fromJson(response.data['user']);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
