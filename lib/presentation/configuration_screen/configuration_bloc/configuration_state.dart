import 'package:equatable/equatable.dart';

abstract class ConfigurationState extends Equatable {
  const ConfigurationState();

  @override
  List<Object> get props => <Object>[];
}

class ConfigurationInitial extends ConfigurationState {}

class StateUpdated extends ConfigurationState {}

class SwitchedIsNeedBattleUpdate extends ConfigurationState {
  const SwitchedIsNeedBattleUpdate({required this.isNeedBattleUpdate});

  final bool isNeedBattleUpdate;

  @override
  List<Object> get props => <Object>[isNeedBattleUpdate];
}

class SwitchedIsNeedChatMessage extends ConfigurationState {
  const SwitchedIsNeedChatMessage({required this.isNeedChatMessage});

  final bool isNeedChatMessage;

  @override
  List<Object> get props => <Object>[isNeedChatMessage];
}
class NotificationEnabled extends ConfigurationState {
  const NotificationEnabled(
      {required this.enableChatMessage, required this.enableBattleUpdate});

  final bool enableChatMessage;
  final bool enableBattleUpdate;

  @override
  List<Object> get props => <Object>[enableChatMessage, enableBattleUpdate];
}