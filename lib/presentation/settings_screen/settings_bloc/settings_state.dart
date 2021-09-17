import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => <Object>[];
}

class SettingsInitial extends SettingsState {}

class StateUpdated extends SettingsState {}

class UserDataUpdated extends SettingsState {}
