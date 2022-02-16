import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/settings_screen/settings_bloc/settings_event.dart';
import 'package:one2one_run/presentation/settings_screen/settings_bloc/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial());

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    }else if (event is UpdateUserData) {
      yield UserDataUpdated();
    }
  }
}
