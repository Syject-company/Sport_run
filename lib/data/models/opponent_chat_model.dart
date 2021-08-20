import 'package:flutter/material.dart';

@immutable
class OpponentChatModel {
//<editor-fold desc="Data Methods">

  const OpponentChatModel({
    required this.id,
    required this.messages,
  });

  factory OpponentChatModel.fromJson(Map<String, dynamic> map) {
    return OpponentChatModel(
      id: map['id'] as String,
      messages: map['messages'] as List<dynamic>,
    );
  }

  final String id;
  final List<dynamic> messages;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OpponentChatModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          messages == other.messages);

  @override
  int get hashCode => id.hashCode ^ messages.hashCode;

  @override
  String toString() {
    return 'OpponentChatModel{${' id: $id,'}${' messages: $messages,'}}';
  }

  OpponentChatModel copyWith({
    String? id,
    List<dynamic>? messages,
  }) {
    return OpponentChatModel(
      id: id ?? this.id,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'messages': messages,
    };
  }

//</editor-fold>
}

@immutable
class Messages {
//<editor-fold desc="Data Methods">

  const Messages({
    required this.id,
    required this.text,
    required this.applicationUserId,
    required this.dateTime,
    required this.messageType,
    required this.messageGroupId,
  });

  factory Messages.fromMap(Map<String, dynamic> map) {
    return Messages(
      id: map['id'] as String,
      text: map['text'] as String,
      applicationUserId: map['applicationUserId'] as String,
      dateTime: map['dateTime'] as String,
      messageType: map['messageType'] as int,
      messageGroupId: map['messageGroupId'] as String,
    );
  }

  final String id;
  final String text;
  final String applicationUserId;
  final String dateTime;
  final int messageType;
  final String messageGroupId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Messages &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          applicationUserId == other.applicationUserId &&
          dateTime == other.dateTime &&
          messageType == other.messageType &&
          messageGroupId == other.messageGroupId);

  @override
  int get hashCode =>
      id.hashCode ^
      text.hashCode ^
      applicationUserId.hashCode ^
      dateTime.hashCode ^
      messageType.hashCode ^
      messageGroupId.hashCode;

  @override
  String toString() {
    return 'Messages{${' id: $id,'}${' text: $text,'}${' applicationUserId: $applicationUserId,'}${' dateTime: $dateTime,'}${' messageType: $messageType,'}${' messageGroupId: $messageGroupId,'}}';
  }

  Messages copyWith({
    String? id,
    String? text,
    String? applicationUserId,
    String? dateTime,
    int? messageType,
    String? messageGroupId,
  }) {
    return Messages(
      id: id ?? this.id,
      text: text ?? this.text,
      applicationUserId: applicationUserId ?? this.applicationUserId,
      dateTime: dateTime ?? this.dateTime,
      messageType: messageType ?? this.messageType,
      messageGroupId: messageGroupId ?? this.messageGroupId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'applicationUserId': applicationUserId,
      'dateTime': dateTime,
      'messageType': messageType,
      'messageGroupId': messageGroupId,
    };
  }

//</editor-fold>
}
