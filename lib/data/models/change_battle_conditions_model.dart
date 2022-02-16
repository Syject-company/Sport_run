import 'package:flutter/material.dart';

@immutable
class ChangeBattleConditionsModel {
//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const ChangeBattleConditionsModel({
    required this.dateTime,
    required this.distance,
  });

  factory ChangeBattleConditionsModel.fromJson(Map<String, dynamic> map) {
    return ChangeBattleConditionsModel(
      dateTime: map['dateTime'] as String,
      distance: map['distance'] as num,
    );
  }

  final String dateTime;
  final num distance;

  ChangeBattleConditionsModel copyWith({
    String? dateTime,
    num? distance,
  }) {
    return ChangeBattleConditionsModel(
      dateTime: dateTime ?? this.dateTime,
      distance: distance ?? this.distance,
    );
  }

  @override
  String toString() {
    return 'ChangeBattleConditions{dateTime: $dateTime, distance: $distance}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChangeBattleConditionsModel &&
          runtimeType == other.runtimeType &&
          dateTime == other.dateTime &&
          distance == other.distance);

  @override
  int get hashCode => dateTime.hashCode ^ distance.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return <String, dynamic>{
      'dateTime': dateTime,
      'distance': distance,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
