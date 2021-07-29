import 'package:flutter/material.dart';

@immutable
class UpdatePasswordModel {
  const UpdatePasswordModel({
    required this.email,
    required this.confirmationCode,
    required this.newPassword,
  });

  factory UpdatePasswordModel.fromJson(Map<String, dynamic> map) {
    return UpdatePasswordModel(
      email: map['email'] as String,
      confirmationCode: map['confirmationCode'] as String,
      newPassword: map['newPassword'] as String,
    );
  }

  final String email;
  final String confirmationCode;
  final String newPassword;

  UpdatePasswordModel copyWith({
    String? email,
    String? confirmationCode,
    String? newPassword,
  }) {
    return UpdatePasswordModel(
      email: email ?? this.email,
      confirmationCode: confirmationCode ?? this.confirmationCode,
      newPassword: newPassword ?? this.newPassword,
    );
  }

  @override
  String toString() {
    return 'UpdatePassword{email: $email, confirmationCode: $confirmationCode, newPassword: $newPassword}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UpdatePasswordModel &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          confirmationCode == other.confirmationCode &&
          newPassword == other.newPassword);

  @override
  int get hashCode =>
      email.hashCode ^ confirmationCode.hashCode ^ newPassword.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return <String, dynamic>{
      'email': email,
      'confirmationCode': confirmationCode,
      'newPassword': newPassword,
    } as Map<String, dynamic>;
  }
}
