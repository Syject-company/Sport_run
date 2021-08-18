import 'package:flutter/material.dart';

@immutable
class SettingsNotificationModel {
//<editor-fold desc="Data Methods">

  const SettingsNotificationModel({
    required this.disableButtlesNotifications,
    required this.disableChatsNotifications,
  });

  factory SettingsNotificationModel.fromJson(Map<String, dynamic> map) {
    return SettingsNotificationModel(
      disableButtlesNotifications: map['disableButtlesNotifications'] as bool,
      disableChatsNotifications: map['disableChatsNotifications'] as bool,
    );
  }

  final bool disableButtlesNotifications;
  final bool disableChatsNotifications;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsNotificationModel &&
          runtimeType == other.runtimeType &&
          disableButtlesNotifications == other.disableButtlesNotifications &&
          disableChatsNotifications == other.disableChatsNotifications);

  @override
  int get hashCode =>
      disableButtlesNotifications.hashCode ^ disableChatsNotifications.hashCode;

  @override
  String toString() {
    return 'SettingsNotification{${' disableButtlesNotifications: $disableButtlesNotifications,'}${' disableChatsNotifications: $disableChatsNotifications,'}}';
  }

  SettingsNotificationModel copyWith({
    bool? disableButtlesNotifications,
    bool? disableChatsNotifications,
  }) {
    return SettingsNotificationModel(
      disableButtlesNotifications:
          disableButtlesNotifications ?? this.disableButtlesNotifications,
      disableChatsNotifications:
          disableChatsNotifications ?? this.disableChatsNotifications,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'disableButtlesNotifications': disableButtlesNotifications,
      'disableChatsNotifications': disableChatsNotifications,
    };
  }

//</editor-fold>
}
