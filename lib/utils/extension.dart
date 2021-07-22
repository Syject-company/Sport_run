import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

extension EmailValidator on String {
  bool isValidEmailInput() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isValidPasswordInput() {
    return RegExp(r'^(?=.*[a-z])').hasMatch(this);
  }
}

extension DateTimeExtension on void {
  String getFormattedDate({
    required DateTime date,
    required TimeOfDay time,
  }) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(
        DateTime(date.year, date.month, date.day, time.hour, time.minute)
            .toLocal());
  }

  String getFormattedDateForUser({
    required DateTime date,
    required TimeOfDay time,
  }) {
    return DateFormat('yyyy-MM-dd HH:mm').format(
        DateTime(date.year, date.month, date.day, time.hour, time.minute)
            .toLocal());
  }
}

extension ToastExtension on void {
  Future<void> toastUnexpectedError() {
    return Fluttertoast.showToast(
        msg: 'Unexpected error happened',
        fontSize: 16.0,
        gravity: ToastGravity.CENTER);
  }
}
