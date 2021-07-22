class BattleRespondModel {
//<editor-fold desc="Data Methods" defaultstate="collapsed">

  BattleRespondModel({
    required this.id,
    required this.battleName,
    required this.diff,
    required this.distance,
    required this.deadlineTime,
    required this.status,
    required this.battleUsers,
    required this.message,
  });

  factory BattleRespondModel.fromJson(Map<String, dynamic> map) {
    return BattleRespondModel(
      id: map['id'] as String,
      message: map['message'] as String,
      battleName: map['battleName'] as String,
      diff: map['diff'] as num,
      distance: map['distance'] as num,
      deadlineTime: map['deadlineTime'] as String,
      status: map['status'] as num,
      battleUsers: map['battleUsers']
          .map<BattleUsers>((e) => BattleUsers.fromJson(e))
          .toList(),
    );
  }

  String id;
  String battleName;
  num diff;
  num distance;
  String deadlineTime;
  num status;
  List<BattleUsers> battleUsers;
  String message;

  BattleRespondModel copyWith({
    String? id,
    String? battleName,
    num? diff,
    num? distance,
    String? deadlineTime,
    num? status,
    String? message,
    List<BattleUsers>? battleUsers,
  }) {
    return BattleRespondModel(
      id: id ?? this.id,
      battleName: battleName ?? this.battleName,
      diff: diff ?? this.diff,
      distance: distance ?? this.distance,
      deadlineTime: deadlineTime ?? this.deadlineTime,
      status: status ?? this.status,
      message: message ?? this.message,
      battleUsers: battleUsers ?? this.battleUsers,
    );
  }

  @override
  String toString() {
    return 'BattleRespondModel{id: $id, message: $message , battleName: $battleName, diff: $diff, distance: $distance, deadlineTime: $deadlineTime, status: $status, battleUsers: $battleUsers}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BattleRespondModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          message == other.message &&
          battleName == other.battleName &&
          diff == other.diff &&
          distance == other.distance &&
          deadlineTime == other.deadlineTime &&
          status == other.status &&
          battleUsers == other.battleUsers);

  @override
  int get hashCode =>
      id.hashCode ^
      message.hashCode ^
      battleName.hashCode ^
      diff.hashCode ^
      distance.hashCode ^
      deadlineTime.hashCode ^
      status.hashCode ^
      battleUsers.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return {
      'id': id,
      'message': message,
      'battleName': battleName,
      'diff': diff,
      'distance': distance,
      'deadlineTime': deadlineTime,
      'status': status,
      'battleUsers': battleUsers,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

class BattleUsers {
//<editor-fold desc="Data Methods" defaultstate="collapsed">

  BattleUsers({
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
      time: map['time'] as num,
      batlleStatus: map['batlleStatus'] as num,
      resultIsConfirmed: map['resultIsConfirmed'] as bool,
      resultIsRejected: map['resultIsRejected'] as bool,
      isCreater: map['isCreater'] as bool,
      photos: map['photos'] as List<dynamic>, //NOte: List<String>
      applicationUser: ApplicationUser.fromJson(map['applicationUser']),
    );
  }

  String id;
  num time;
  num batlleStatus;
  bool resultIsConfirmed;
  bool resultIsRejected;
  bool isCreater;
  List<dynamic> photos;
  ApplicationUser applicationUser;

  BattleUsers copyWith({
    String? id,
    num? time,
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
    return {
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

class ApplicationUser {
//<editor-fold desc="Data Methods" defaultstate="collapsed">

  ApplicationUser({
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

  String id;
  String email;
  String nickName;
  String description;
  String moto;
  bool isMetric;
  num pace;
  num weeklyDistance;
  num rank;
  num workoutsPerWeek;
  num wins;
  num loses;
  num draws;
  num discarded;
  num score;
  String? photoLink;

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
    return {
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
