import 'package:equatable/equatable.dart';

abstract class ConfigurationEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateState extends ConfigurationEvent {}

class SwitchIsNeedBattleUpdate extends ConfigurationEvent {
  SwitchIsNeedBattleUpdate({required this.isNeedBattleUpdate});

  final bool isNeedBattleUpdate;

  @override
  List<Object> get props => <Object>[isNeedBattleUpdate];
}

class SwitchIsNeedChatMessage extends ConfigurationEvent {
  SwitchIsNeedChatMessage({required this.isNeedChatMessage});

  final bool isNeedChatMessage;

  @override
  List<Object> get props => <Object>[isNeedChatMessage];
}

class EnableNotification extends ConfigurationEvent {
   EnableNotification(
      {required this.enableChatMessage, required this.enableBattleUpdate});

  final bool enableChatMessage;
  final bool enableBattleUpdate;

  @override
  List<Object> get props => <Object>[enableChatMessage, enableBattleUpdate];
}
