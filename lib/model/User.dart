import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'User.g.dart';

@HiveType(typeId: 0)
class UserModel extends Equatable {
  @HiveField(0)
  String id;
  @HiveField(1)
  String email;
  @HiveField(2)
  String password;
  @HiveField(3)
  String name;

  UserModel(
    this.id,
    this.email,
    this.password,
    this.name,
  );

  // //from json
  // factory UserModel.fromJson(Map<String, dynamic> json) {
  //   return UserModel(
  //     json['_id'] as String,
  //     json['email'] as String,
  //     json['password'] as String,
  //     json['name'] as String,
  //   );
  // }

  // //to json
  // UserModel toJson() {
  //   return UserModel(
  //     id,
  //     email,
  //     password,
  //     name,
  //   );
  // }

  @override
  // TODO: implement props
  List<Object> get props => [id, email, password, name];

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, password: $password, name: $name)';
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
  }) {
    return UserModel(
      id ?? this.id,
      email ?? this.email,
      password ?? this.password,
      name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      map['id'] ?? '',
      map['email'] ?? '',
      map['password'] ?? '',
      map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
