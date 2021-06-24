import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class UpdateState extends EditProfileEvent {}

class SelectKmOrMile extends EditProfileEvent {
  SelectKmOrMile(this.isKM);

  final bool isKM;

  @override
  List<Object> get props => [isKM];
}

class SelectTimesPerWeek extends EditProfileEvent {
  SelectTimesPerWeek(this.timesPerWeek);

  final int timesPerWeek;

  @override
  List<Object> get props => [timesPerWeek];
}

class SaveUserData extends EditProfileEvent {}