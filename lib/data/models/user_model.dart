class UserModel {


  String id;
  String? email;
  String? nickName;
  String description;

  //<editor-fold desc="Data Methods" defaultstate="collapsed">

  UserModel({
    required this.id,
    required this.email,
    required this.nickName,
    required this.description,
    required this.moto,
    required this.photoLink,
    required this.isMetric,
    required this.pace,
    required this.weeklyDistance,
    required this.rank,
    required this.workoutsPerWeek,
    required this.wins,
    required this.loses,
    required this.draws,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? nickName,
    String? description,
    String? moto,
    String? photoLink,
    bool? isMetric,
    num? pace,
    num? weeklyDistance,
    num? rank,
    num? workoutsPerWeek,
    num? wins,
    num? loses,
    num? draws,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nickName: nickName ?? this.nickName,
      description: description ?? this.description,
      moto: moto ?? this.moto,
      photoLink: photoLink ?? this.photoLink,
      isMetric: isMetric ?? this.isMetric,
      pace: pace ?? this.pace,
      weeklyDistance: weeklyDistance ?? this.weeklyDistance,
      rank: rank ?? this.rank,
      workoutsPerWeek: workoutsPerWeek ?? this.workoutsPerWeek,
      wins: wins ?? this.wins,
      loses: loses ?? this.loses,
      draws: draws ?? this.draws,
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, email: $email, nickName: $nickName, description: $description, moto: $moto, photoLink: $photoLink, isMetric: $isMetric, pace: $pace, weeklyDistance: $weeklyDistance, rank: $rank, workoutsPerWeek: $workoutsPerWeek, wins: $wins, loses: $loses, draws: $draws}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          nickName == other.nickName &&
          description == other.description &&
          moto == other.moto &&
          photoLink == other.photoLink &&
          isMetric == other.isMetric &&
          pace == other.pace &&
          weeklyDistance == other.weeklyDistance &&
          rank == other.rank &&
          workoutsPerWeek == other.workoutsPerWeek &&
          wins == other.wins &&
          loses == other.loses &&
          draws == other.draws);

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      nickName.hashCode ^
      description.hashCode ^
      moto.hashCode ^
      photoLink.hashCode ^
      isMetric.hashCode ^
      pace.hashCode ^
      weeklyDistance.hashCode ^
      rank.hashCode ^
      workoutsPerWeek.hashCode ^
      wins.hashCode ^
      loses.hashCode ^
      draws.hashCode;

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      nickName: map['nickName'] as String,
      description: map['description'] as String,
      moto: map['moto'] as String,
      photoLink: map['photoLink'] as String,
      isMetric: map['isMetric'] as bool,
      pace: map['pace'] as num,
      weeklyDistance: map['weeklyDistance'] as num,
      rank: map['rank'] as num,
      workoutsPerWeek: map['workoutsPerWeek'] as num,
      wins: map['wins'] as num,
      loses: map['loses'] as num,
      draws: map['draws'] as num,
    );
  }

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'email': this.email,
      'nickName': this.nickName,
      'description': this.description,
      'moto': this.moto,
      'photoLink': this.photoLink,
      'isMetric': this.isMetric,
      'pace': this.pace,
      'weeklyDistance': this.weeklyDistance,
      'rank': this.rank,
      'workoutsPerWeek': this.workoutsPerWeek,
      'wins': this.wins,
      'loses': this.loses,
      'draws': this.draws,
    } as Map<String, dynamic>;
  }

  //</editor-fold>

  String moto;
  String? photoLink;
  bool isMetric;
  num pace;
  num weeklyDistance;
  num rank;
  num workoutsPerWeek;
  num wins;
  num loses;
  num draws;



}
