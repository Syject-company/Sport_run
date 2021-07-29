import 'package:flutter/material.dart';

@immutable
class ChangePassEmailModel {
  const ChangePassEmailModel({
    required this.email,
  });

  factory ChangePassEmailModel.fromJson(Map<String, dynamic> map) {
    return ChangePassEmailModel(
      email: map['email'] as String,
    );
  }

  final String email;

  ChangePassEmailModel copyWith({
    String? email,
  }) {
    return ChangePassEmailModel(
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'ChangePassEmailModel{email: $email}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChangePassEmailModel &&
          runtimeType == other.runtimeType &&
          email == other.email);

  @override
  int get hashCode => email.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return <String, dynamic>{
      'email': email,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
