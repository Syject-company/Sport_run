import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateState extends SettingsEvent {}

class SwitchIsNeedBattleUpdate extends SettingsEvent {
  SwitchIsNeedBattleUpdate({required this.isNeedBattleUpdate});

  final bool isNeedBattleUpdate;

  @override
  List<Object> get props => <Object>[isNeedBattleUpdate];
}

class SwitchIsNeedChatMessage extends SettingsEvent {
  SwitchIsNeedChatMessage({required this.isNeedChatMessage});

  final bool isNeedChatMessage;

  @override
  List<Object> get props => <Object>[isNeedChatMessage];
}

class EnableNotification extends SettingsEvent {
   EnableNotification(
      {required this.enableChatMessage, required this.enableBattleUpdate});

  final bool enableChatMessage;
  final bool enableBattleUpdate;

  @override
  List<Object> get props => <Object>[enableChatMessage, enableBattleUpdate];
}
