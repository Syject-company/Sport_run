import 'package:equatable/equatable.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object> get props => <Object>[];
}

class EditProfileInitial extends EditProfileState {}

class StateUpdated extends EditProfileState {}

class KmOrMileIsSelected extends EditProfileState {
  const KmOrMileIsSelected(this.isKM);

  final bool isKM;

  @override
  List<Object> get props => <Object>[isKM];
}

class TimesPerWeekIsSelected extends EditProfileState {
  const TimesPerWeekIsSelected(this.timesPerWeek);

  final int timesPerWeek;

  @override
  List<Object> get props => <Object>[timesPerWeek];
}

class UserDataSaved extends EditProfileState {}

class DistanceValueChanged extends EditProfileState {
  const DistanceValueChanged(this.value);

  final double value;

  @override
  List<Object> get props => <Object>[value];
}

class PaceValueChanged extends EditProfileState {
  const PaceValueChanged(this.value);

  final double value;

  @override
  List<Object> get props => <Object>[value];
}
