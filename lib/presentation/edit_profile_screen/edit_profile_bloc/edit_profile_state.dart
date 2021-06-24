import 'package:equatable/equatable.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object> get props => [];
}

class EditProfileInitial extends EditProfileState {}

class StateUpdated extends EditProfileState {}

class KmOrMileIsSelected extends EditProfileState {
  KmOrMileIsSelected(this.isKM);

  final bool isKM;

  @override
  List<Object> get props => [isKM];
}

class TimesPerWeekIsSelected extends EditProfileState {
  TimesPerWeekIsSelected(this.timesPerWeek);

  final int timesPerWeek;

  @override
  List<Object> get props => [timesPerWeek];
}

class UserDataSaved extends EditProfileState {}



