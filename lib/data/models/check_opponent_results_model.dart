import 'package:flutter/material.dart';

@immutable
class CheckOpponentResultsModel {
//<editor-fold desc="Data Methods">

  const CheckOpponentResultsModel({
    required this.name,
    required this.userPhoto,
    required this.rank,
    required this.time,
    required this.distance,
    required this.battlePhotos,
  });

  factory CheckOpponentResultsModel.fromJson(Map<String, dynamic> map) {
    return CheckOpponentResultsModel(
      name: map['name'] as String,
      userPhoto: map['userPhoto'] as String,
      rank: map['rank'] as String,
      time: map['time'] as String,
      distance: map['distance'] as String,
      battlePhotos: map['battlePhotos'] as List<String>,
    );
  }

  final String name;
  final String? userPhoto;
  final String rank;
  final String time;
  final String distance;
  final List<String> battlePhotos;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CheckOpponentResultsModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          userPhoto == other.userPhoto &&
          rank == other.rank &&
          time == other.time &&
          distance == other.distance &&
          battlePhotos == other.battlePhotos);

  @override
  int get hashCode =>
      name.hashCode ^
      userPhoto.hashCode ^
      rank.hashCode ^
      time.hashCode ^
      distance.hashCode ^
      battlePhotos.hashCode;

  @override
  String toString() {
    return 'CheckOpponentResultsModel{${' name: $name,'}${' userPhoto: $userPhoto,'}${' rank: $rank,'}${' time: $time,'}${' distance: $distance,'}${' battlePhotos: $battlePhotos,'}}';
  }

  CheckOpponentResultsModel copyWith({
    String? name,
    String? userPhoto,
    String? rank,
    String? time,
    String? distance,
    List<String>? battlePhotos,
  }) {
    return CheckOpponentResultsModel(
      name: name ?? this.name,
      userPhoto: userPhoto ?? this.userPhoto,
      rank: rank ?? this.rank,
      time: time ?? this.time,
      distance: distance ?? this.distance,
      battlePhotos: battlePhotos ?? this.battlePhotos,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'userPhoto': userPhoto,
      'rank': rank,
      'time': time,
      'distance': distance,
      'battlePhotos': battlePhotos,
    };
  }

//</editor-fold>
}
