import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/configuration_screen/configuration_bloc/configuration_event.dart';
import 'package:one2one_run/presentation/configuration_screen/configuration_bloc/configuration_state.dart';


class ConfigurationBloc extends Bloc<ConfigurationEvent, ConfigurationState> {
  ConfigurationBloc() : super(ConfigurationInitial());

  @override
  Stream<ConfigurationState> mapEventToState(ConfigurationEvent event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    } else if (event is SwitchIsNeedBattleUpdate) {
      yield SwitchedIsNeedBattleUpdate(
          isNeedBattleUpdate: event.isNeedBattleUpdate);
    } else if (event is SwitchIsNeedChatMessage) {
      yield SwitchedIsNeedChatMessage(
          isNeedChatMessage: event.isNeedChatMessage);
    } else if (event is EnableNotification) {
      yield NotificationEnabled(
          enableBattleUpdate: event.enableBattleUpdate,
          enableChatMessage: event.enableChatMessage);
    }
  }
}
