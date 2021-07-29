import 'dart:core';

import 'package:flutter/material.dart';

@immutable
class UserProfileRequestModel {
  const UserProfileRequestModel({
    required this.nickName,
    required this.isMetric,
    required this.pace,
    required this.weeklyDistance,
    required this.workoutsPerWeek,
    required this.moto,
    required this.description,
  });

  factory UserProfileRequestModel.fromJson(Map<String, dynamic> map) {
    return UserProfileRequestModel(
      nickName: map['nickName'] as String,
      isMetric: map['isMetric'] as bool,
      pace: map['pace'] as num,
      weeklyDistance: map['weeklyDistance'] as num,
      workoutsPerWeek: map['workoutsPerWeek'] as int,
      moto: map['moto'] as String,
      description: map['description'] as String,
    );
  }

  final String nickName;
  final bool isMetric;
  final num pace;
  final num weeklyDistance;
  final int workoutsPerWeek;
  final String moto;
  final String description;

  UserProfileRequestModel copyWith({
    String? nickName,
    bool? isMetric,
    num? pace,
    num? weeklyDistance,
    int? workoutsPerWeek,
    String? moto,
    String? description,
  }) {
    return UserProfileRequestModel(
      nickName: nickName ?? this.nickName,
      isMetric: isMetric ?? this.isMetric,
      pace: pace ?? this.pace,
      weeklyDistance: weeklyDistance ?? this.weeklyDistance,
      workoutsPerWeek: workoutsPerWeek ?? this.workoutsPerWeek,
      moto: moto ?? this.moto,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'UserProfileRequestModel{nickName: $nickName, isMetric: $isMetric, pace: $pace, weeklyDistance: $weeklyDistance, workoutsPerWeek: $workoutsPerWeek, moto: $moto, description: $description}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileRequestModel &&
          runtimeType == other.runtimeType &&
          nickName == other.nickName &&
          isMetric == other.isMetric &&
          pace == other.pace &&
          weeklyDistance == other.weeklyDistance &&
          workoutsPerWeek == other.workoutsPerWeek &&
          moto == other.moto &&
          description == other.description);

  @override
  int get hashCode =>
      nickName.hashCode ^
      isMetric.hashCode ^
      pace.hashCode ^
      weeklyDistance.hashCode ^
      workoutsPerWeek.hashCode ^
      moto.hashCode ^
      description.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return <String, dynamic>{
      'nickName': nickName,
      'isMetric': isMetric,
      'pace': pace,
      'weeklyDistance': weeklyDistance,
      'workoutsPerWeek': workoutsPerWeek,
      'moto': moto,
      'description': description,
    } as Map<String, dynamic>;
  }
}
