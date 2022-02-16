import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateState extends SettingsEvent {}

class UpdateUserData extends SettingsEvent {}
