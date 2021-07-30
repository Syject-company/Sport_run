import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateState extends EditProfileEvent {}

class SelectKmOrMile extends EditProfileEvent {
  SelectKmOrMile(this.isKM);

  final bool isKM;

  @override
  List<Object> get props => <Object>[isKM];
}

class SelectTimesPerWeek extends EditProfileEvent {
  SelectTimesPerWeek(this.timesPerWeek);

  final int timesPerWeek;

  @override
  List<Object> get props => <Object>[timesPerWeek];
}

class SaveUserData extends EditProfileEvent {}
