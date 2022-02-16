import 'package:flutter/material.dart';

@immutable
class EnjoyResponseModel {
//<editor-fold desc="Data Methods">

  const EnjoyResponseModel({
    required this.id,
    required this.email,
    required this.nickName,
    required this.description,
    required this.moto,
    required this.isMetric,
    required this.pace,
    required this.weeklyDistance,
    required this.rank,
    required this.workoutsPerWeek,
    required this.wins,
    required this.loses,
    required this.draws,
    required this.discarded,
    required this.score,
    required this.photoLink,
  });

  factory EnjoyResponseModel.fromJson(Map<String, dynamic> map) {
    return EnjoyResponseModel(
      id: map['id'] as String,
      email: map['email'] as String,
      nickName: map['nickName'] as String,
      description: map['description'] as String,
      moto: map['moto'] as String,
      isMetric: map['isMetric'] as bool,
      pace: map['pace'] as num,
      weeklyDistance: map['weeklyDistance'] as num,
      rank: map['rank'] as num,
      workoutsPerWeek: map['workoutsPerWeek'] as num,
      wins: map['wins'] as num,
      loses: map['loses'] as num,
      draws: map['draws'] as num,
      discarded: map['discarded'] as num,
      score: map['score'] as num,
      photoLink: map['photoLink'] as String,
    );
  }

  final String id;
  final String email;
  final String? nickName;
  final String? description;
  final String? moto;
  final bool isMetric;
  final num pace;
  final num weeklyDistance;
  final num rank;
  final num workoutsPerWeek;
  final num wins;
  final num loses;
  final num draws;
  final num discarded;
  final num score;
  final String? photoLink;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnjoyResponseModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          nickName == other.nickName &&
          description == other.description &&
          moto == other.moto &&
          isMetric == other.isMetric &&
          pace == other.pace &&
          weeklyDistance == other.weeklyDistance &&
          rank == other.rank &&
          workoutsPerWeek == other.workoutsPerWeek &&
          wins == other.wins &&
          loses == other.loses &&
          draws == other.draws &&
          discarded == other.discarded &&
          score == other.score &&
          photoLink == other.photoLink);

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      nickName.hashCode ^
      description.hashCode ^
      moto.hashCode ^
      isMetric.hashCode ^
      pace.hashCode ^
      weeklyDistance.hashCode ^
      rank.hashCode ^
      workoutsPerWeek.hashCode ^
      wins.hashCode ^
      loses.hashCode ^
      draws.hashCode ^
      discarded.hashCode ^
      score.hashCode ^
      photoLink.hashCode;

  @override
  String toString() {
    return 'EnjoyResponseModel{${' id: $id,'}${' email: $email,'}${' nickName: $nickName,'}${' description: $description,'}${' moto: $moto,'}${' isMetric: $isMetric,'}${' pace: $pace,'}${' weeklyDistance: $weeklyDistance,'}${' rank: $rank,'}${' workoutsPerWeek: $workoutsPerWeek,'}${' wins: $wins,'}${' loses: $loses,'}${' draws: $draws,'}${' discarded: $discarded,'}${' score: $score,'}${' photoLink: $photoLink,'}}';
  }

  EnjoyResponseModel copyWith({
    String? id,
    String? email,
    String? nickName,
    String? description,
    String? moto,
    bool? isMetric,
    num? pace,
    num? weeklyDistance,
    num? rank,
    num? workoutsPerWeek,
    num? wins,
    num? loses,
    num? draws,
    num? discarded,
    num? score,
    String? photoLink,
  }) {
    return EnjoyResponseModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nickName: nickName ?? this.nickName,
      description: description ?? this.description,
      moto: moto ?? this.moto,
      isMetric: isMetric ?? this.isMetric,
      pace: pace ?? this.pace,
      weeklyDistance: weeklyDistance ?? this.weeklyDistance,
      rank: rank ?? this.rank,
      workoutsPerWeek: workoutsPerWeek ?? this.workoutsPerWeek,
      wins: wins ?? this.wins,
      loses: loses ?? this.loses,
      draws: draws ?? this.draws,
      discarded: discarded ?? this.discarded,
      score: score ?? this.score,
      photoLink: photoLink ?? this.photoLink,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'nickName': nickName,
      'description': description,
      'moto': moto,
      'isMetric': isMetric,
      'pace': pace,
      'weeklyDistance': weeklyDistance,
      'rank': rank,
      'workoutsPerWeek': workoutsPerWeek,
      'wins': wins,
      'loses': loses,
      'draws': draws,
      'discarded': discarded,
      'score': score,
      'photoLink': photoLink,
    };
  }

//</editor-fold>
}
