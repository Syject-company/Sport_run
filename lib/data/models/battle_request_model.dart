import 'package:flutter/material.dart';

@immutable
class BattleRequestModel {
//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const BattleRequestModel({
    required this.dateTime,
    required this.distance,
    required this.opponentId,
    required this.message,
    required this.battleName,
  });


  factory BattleRequestModel.fromJson(Map<String, dynamic> map) {
    return BattleRequestModel(
      dateTime: map['dateTime'] as String,
      distance: map['distance'] as num,
      opponentId: map['opponentId'] as String,
      message: map['message'] as String,
      battleName: map['battleName'] as String?,
    );
  }

  final String dateTime;
  final num distance;
  final String opponentId;
  final String message;
  final String? battleName;

  BattleRequestModel copyWith({
    String? dateTime,
    num? distance,
    String? opponentId,
    String? message,
    String? battleName,
  }) {
    return BattleRequestModel(
      dateTime: dateTime ?? this.dateTime,
      distance: distance ?? this.distance,
      opponentId: opponentId ?? this.opponentId,
      message: message ?? this.message,
      battleName: battleName ?? this.battleName,
    );
  }

  @override
  String toString() {
    return 'BattleRequestModel{dateTime: $dateTime, distance: $distance, opponentId: $opponentId, message: $message, battleName: $battleName}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BattleRequestModel &&
          runtimeType == other.runtimeType &&
          dateTime == other.dateTime &&
          distance == other.distance &&
          opponentId == other.opponentId &&
          message == other.message &&
          battleName == other.battleName);

  @override
  int get hashCode =>
      dateTime.hashCode ^
      distance.hashCode ^
      opponentId.hashCode ^
      message.hashCode ^
      battleName.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return <String, dynamic>{
      'dateTime': dateTime,
      'distance': distance,
      'opponentId': opponentId,
      'message': message,
      'battleName': battleName,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
