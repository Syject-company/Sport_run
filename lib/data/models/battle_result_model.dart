import 'package:flutter/material.dart';

@immutable
class BattleResultModel {
//<editor-fold desc="Data Methods">

  const BattleResultModel({
    required this.photos,
    required this.time,
  });

  factory BattleResultModel.fromJson(Map<String, dynamic> map) {
    return BattleResultModel(
      photos: map['Photos'] as List<String>,
      time: map['Time'] as String,
    );
  }

  final List<String> photos;
  final String time;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BattleResultModel &&
          runtimeType == other.runtimeType &&
          photos == other.photos &&
          time == other.time);

  @override
  int get hashCode => photos.hashCode ^ time.hashCode;

  @override
  String toString() {
    return 'BattleResultModel{${' Photos: $photos,'}${' Time: $time,'}}';
  }

  BattleResultModel copyWith({
    List<String>? photos,
    String? time,
  }) {
    return BattleResultModel(
      photos: photos ?? this.photos,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Photos': photos,
      'Time': time,
    };
  }

//</editor-fold>
}
