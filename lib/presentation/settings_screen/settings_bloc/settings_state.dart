import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => <Object>[];
}

class SettingsInitial extends SettingsState {}

class StateUpdated extends SettingsState {}

class SwitchedIsNeedBattleUpdate extends SettingsState {
  const SwitchedIsNeedBattleUpdate({required this.isNeedBattleUpdate});

  final bool isNeedBattleUpdate;

  @override
  List<Object> get props => <Object>[isNeedBattleUpdate];
}

class SwitchedIsNeedChatMessage extends SettingsState {
  const SwitchedIsNeedChatMessage({required this.isNeedChatMessage});

  final bool isNeedChatMessage;

  @override
  List<Object> get props => <Object>[isNeedChatMessage];
}
class NotificationEnabled extends SettingsState {
  const NotificationEnabled(
      {required this.enableChatMessage, required this.enableBattleUpdate});

  final bool enableChatMessage;
  final bool enableBattleUpdate;

  @override
  List<Object> get props => <Object>[enableChatMessage, enableBattleUpdate];
}