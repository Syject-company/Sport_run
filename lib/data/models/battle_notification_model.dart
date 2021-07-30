import 'package:flutter/material.dart';

@immutable
class BattleNotificationModel {
//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const BattleNotificationModel({
    required this.battleId,
  });

  factory BattleNotificationModel.fromJson(Map<String, dynamic> map) {
    return BattleNotificationModel(
      battleId: map['battleId'] as String,
    );
  }

  final String battleId;

  BattleNotificationModel copyWith({
    String? battleId,
  }) {
    return BattleNotificationModel(
      battleId: battleId ?? this.battleId,
    );
  }

  @override
  String toString() {
    return 'BattleNotificationModel{battleId: $battleId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BattleNotificationModel &&
          runtimeType == other.runtimeType &&
          battleId == other.battleId);

  @override
  int get hashCode => battleId.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return <String, dynamic>{
      'battleId': battleId,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
