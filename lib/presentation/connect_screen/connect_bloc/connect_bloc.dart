import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/connect_screen/connect_bloc/connect_event.dart';
import 'package:one2one_run/presentation/connect_screen/connect_bloc/connect_state.dart';

class ConnectBloc extends Bloc<ConnectEvent, ConnectState> {
  ConnectBloc() : super(ConnectInitial());

  @override
  Stream<ConnectState> mapEventToState(ConnectEvent event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    } else if (event is NavigateToUserInfo) {
      yield NavigatedToUserInfo(event.userModel);
    }
  }
}
