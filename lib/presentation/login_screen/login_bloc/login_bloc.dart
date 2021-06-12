import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/login_screen/login_bloc/login_event.dart';
import 'package:one2one_run/presentation/login_screen/login_bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    } else if (event is ShowOrHidePass) {
      yield PassIsShownOrHidden();
    } else if (event is NavigateToHome) {
      yield NavigatedToHome();
    } else if (event is NavigateToRegister) {
      yield NavigatedToRegister();
    } else if (event is NavigateToForgotPassword) {
      yield NavigatedToForgotPassword();
    } else if (event is SignInGoogle) {
      yield SignInedGoogle(token: event.token);
    } else if (event is SignInApple) {
      yield SignInedApple(token: event.token);
    } else if (event is CheckFields) {
      yield FieldsChecked();
    }
  }
}
