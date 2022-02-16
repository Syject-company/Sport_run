import 'package:flutter/material.dart';

@immutable
class AccessUserModel {
  const AccessUserModel({
    required this.email,
    required this.password,
  });

  factory AccessUserModel.fromJson(Map<String, dynamic> json) {
    return AccessUserModel(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  final String email;
  final String password;

  AccessUserModel copyWith({
    String? email,
    String? password,
  }) {
    return AccessUserModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'RegisterModel{email: $email, password: $password}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccessUserModel &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password);

  @override
  int get hashCode => email.hashCode ^ password.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return <String, dynamic>{
      'email': email,
      'password': password,
    } as Map<String, dynamic>;
  }
}
