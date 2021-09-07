import 'package:flutter/material.dart';

@immutable
class BattleRespondModel {
//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const BattleRespondModel({
    required this.id,
    required this.battleName,
    required this.finishTime,
    required this.distance,
    required this.deadlineTime,
    required this.status,
    required this.battleUsers,
    required this.message,
    required this.timeLeft,
    required this.statusReason,
  });

  factory BattleRespondModel.fromJson(Map<String, dynamic> map) {
    return BattleRespondModel(
      id: map['id'] as String,
      message: map['message'] as String,
      timeLeft: map['timeLeft'] as String,
      statusReason: map['statusReason'] as String,
      battleName: map['battleName'] as String,
      finishTime: map['finishTime'] as String,
      distance: map['distance'] as num,
      deadlineTime: map['deadlineTime'] as String,
      status: map['status'] as num,
      battleUsers: (map['battleUsers'] as List<dynamic>).map<BattleUsers>(
              (dynamic e) =>
                  BattleUsers.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  final String id;
  final String? battleName;
  final String? finishTime;
  final num distance;
  final String deadlineTime;
  final num status;
  final List<BattleUsers> battleUsers;
  final String? message;
  final String? timeLeft;
  final String? statusReason;

  BattleRespondModel copyWith({
    String? id,
    String? battleName,
    String? finishTime,
    num? distance,
    String? deadlineTime,
    num? status,
    String? message,
    List<BattleUsers>? battleUsers,
  }) {
    return BattleRespondModel(
      id: id ?? this.id,
      battleName: battleName ?? this.battleName,
      finishTime: finishTime ?? this.finishTime,
      distance: distance ?? this.distance,
      deadlineTime: deadlineTime ?? this.deadlineTime,
      status: status ?? this.status,
      message: message ?? this.message,
      timeLeft: timeLeft ?? timeLeft,
      statusReason: statusReason ?? statusReason,
      battleUsers: battleUsers ?? this.battleUsers,
    );
  }

  @override
  String toString() {
    return 'BattleRespondModel{id: $id, message: $message , timeLeft: $timeLeft, statusReason: $statusReason, battleName: $battleName, finishTime: $finishTime, distance: $distance, deadlineTime: $deadlineTime, status: $status, battleUsers: $battleUsers}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BattleRespondModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          message == other.message &&
          timeLeft == other.timeLeft &&
          statusReason == other.statusReason &&
          battleName == other.battleName &&
          finishTime == other.finishTime &&
          distance == other.distance &&
          deadlineTime == other.deadlineTime &&
          status == other.status &&
          battleUsers == other.battleUsers);

  @override
  int get hashCode =>
      id.hashCode ^
      message.hashCode ^
      timeLeft.hashCode ^
      statusReason.hashCode ^
      battleName.hashCode ^
      finishTime.hashCode ^
      distance.hashCode ^
      deadlineTime.hashCode ^
      status.hashCode ^
      battleUsers.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return <String, dynamic>{
      'id': id,
      'message': message,
      'timeLeft': timeLeft,
      'statusReason': statusReason,
      'battleName': battleName,
      'finishTime': finishTime,
      'distance': distance,
      'deadlineTime': deadlineTime,
      'status': status,
      'battleUsers': battleUsers,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

@immutable
class BattleUsers {
//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const BattleUsers({
    required this.id,
    required this.time,
    required this.batlleStatus,
    required this.resultIsConfirmed,
    required this.resultIsRejected,
    required this.isCreater,
    required this.photos,
    required this.applicationUser,
  });

  factory BattleUsers.fromJson(Map<String, dynamic> map) {
    return BattleUsers(
      id: map['id'] as String,
      time: map['time'] as String,
      batlleStatus: map['batlleStatus'] as num?,
      resultIsConfirmed: map['resultIsConfirmed'] as bool,
      resultIsRejected: map['resultIsRejected'] as bool,
      isCreater: map['isCreater'] as bool,
      //NOte: List<String>
      photos: map['photos'] as List<dynamic>,
      applicationUser: ApplicationUser.fromJson(
          map['applicationUser'] as Map<String, dynamic>),
    );
  }

  final String id;
  final String time;
  final num? batlleStatus;
  final bool resultIsConfirmed;
  final bool resultIsRejected;
  final bool isCreater;
  final List<dynamic> photos;
  final ApplicationUser applicationUser;

  BattleUsers copyWith({
    String? id,
    String? time,
    num? batlleStatus,
    bool? resultIsConfirmed,
    bool? resultIsRejected,
    bool? isCreater,
    List<dynamic>? photos,
    ApplicationUser? applicationUser,
  }) {
    return BattleUsers(
      id: id ?? this.id,
      time: time ?? this.time,
      batlleStatus: batlleStatus ?? this.batlleStatus,
      resultIsConfirmed: resultIsConfirmed ?? this.resultIsConfirmed,
      resultIsRejected: resultIsRejected ?? this.resultIsRejected,
      isCreater: isCreater ?? this.isCreater,
      photos: photos ?? this.photos,
      applicationUser: applicationUser ?? this.applicationUser,
    );
  }

  @override
  String toString() {
    return 'BattleUsers{id: $id, time: $time, batlleStatus: $batlleStatus, resultIsConfirmed: $resultIsConfirmed, resultIsRejected: $resultIsRejected, isCreater: $isCreater, photos: $photos, applicationUser: $applicationUser}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BattleUsers &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          time == other.time &&
          batlleStatus == other.batlleStatus &&
          resultIsConfirmed == other.resultIsConfirmed &&
          resultIsRejected == other.resultIsRejected &&
          isCreater == other.isCreater &&
          photos == other.photos &&
          applicationUser == other.applicationUser);

  @override
  int get hashCode =>
      id.hashCode ^
      time.hashCode ^
      batlleStatus.hashCode ^
      resultIsConfirmed.hashCode ^
      resultIsRejected.hashCode ^
      isCreater.hashCode ^
      photos.hashCode ^
      applicationUser.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return <String, dynamic>{
      'id': id,
      'time': time,
      'batlleStatus': batlleStatus,
      'resultIsConfirmed': resultIsConfirmed,
      'resultIsRejected': resultIsRejected,
      'isCreater': isCreater,
      'photos': photos,
      'applicationUser': applicationUser,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

@immutable
class ApplicationUser {
//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const ApplicationUser({
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

  factory ApplicationUser.fromJson(Map<String, dynamic> map) {
    return ApplicationUser(
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
      photoLink: map['photoLink'] as String?,
    );
  }

  final String id;
  final String email;
  final String nickName;
  final String description;
  final String moto;
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

  ApplicationUser copyWith({
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
    return ApplicationUser(
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

  @override
  String toString() {
    return 'ApplicationUser{id: $id, email: $email, nickName: $nickName, description: $description, moto: $moto, isMetric: $isMetric, pace: $pace, weeklyDistance: $weeklyDistance, rank: $rank, workoutsPerWeek: $workoutsPerWeek, wins: $wins, loses: $loses, draws: $draws, discarded: $discarded, score: $score, photoLink: $photoLink}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApplicationUser &&
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

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
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
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
