import 'package:flutter/material.dart';

@immutable
class RunnerDataModel {
  const RunnerDataModel({
    required this.nickName,
    required this.isMetric,
    required this.pace,
    required this.weeklyDistance,
    required this.workoutsPerWeek,
  });

  factory RunnerDataModel.fromJson(Map<String, dynamic> map) {
    return RunnerDataModel(
      nickName: map['nickName'] as String,
      isMetric: map['isMetric'] as bool,
      pace: map['pace'] as double,
      weeklyDistance: map['weeklyDistance'] as double,
      workoutsPerWeek: map['workoutsPerWeek'] as int,
    );
  }

  final String nickName;
  final bool isMetric;
  final double pace;
  final double weeklyDistance;
  final int workoutsPerWeek;

  RunnerDataModel copyWith({
    String? nickName,
    bool? isMetric,
    double? pace,
    double? weeklyDistance,
    int? workoutsPerWeek,
  }) {
    return RunnerDataModel(
      nickName: nickName ?? this.nickName,
      isMetric: isMetric ?? this.isMetric,
      pace: pace ?? this.pace,
      weeklyDistance: weeklyDistance ?? this.weeklyDistance,
      workoutsPerWeek: workoutsPerWeek ?? this.workoutsPerWeek,
    );
  }

  @override
  String toString() {
    return 'RunnerDataModel{nickName: $nickName, isMetric: $isMetric, pace: $pace, weeklyDistance: $weeklyDistance, workoutsPerWeek: $workoutsPerWeek}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RunnerDataModel &&
          runtimeType == other.runtimeType &&
          nickName == other.nickName &&
          isMetric == other.isMetric &&
          pace == other.pace &&
          weeklyDistance == other.weeklyDistance &&
          workoutsPerWeek == other.workoutsPerWeek);

  @override
  int get hashCode =>
      nickName.hashCode ^
      isMetric.hashCode ^
      pace.hashCode ^
      weeklyDistance.hashCode ^
      workoutsPerWeek.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return <String, dynamic>{
      'nickName': nickName,
      'isMetric': isMetric,
      'pace': pace,
      'weeklyDistance': weeklyDistance,
      'workoutsPerWeek': workoutsPerWeek,
    } as Map<String, dynamic>;
  }
}
