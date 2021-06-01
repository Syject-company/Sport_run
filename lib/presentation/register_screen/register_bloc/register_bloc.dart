import 'package:bloc/bloc.dart';
import 'package:one2one_run/_screen/login_bloc/login_event.dart';
import 'package:one2one_run/_screen/login_bloc/login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    }
  }
}
