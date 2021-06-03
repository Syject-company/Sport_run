import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/register_screen/register_bloc/register_event.dart';
import 'package:one2one_run/presentation/register_screen/register_bloc/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    } else if (event is ShowOrHidePass) {
      yield PassIsShownOrHidden();
    } else if (event is NavigateToRunnersData) {
      yield NavigatedToRunnersData();
    } else if (event is NavigateToSignIn) {
      yield NavigatedToSignIn();
    } else if (event is AcceptTerms) {
      yield TermsIsAccepted();
    } else if (event is SignInGoogle) {
      yield SignInedGoogle();
    } else if (event is SignInApple) {
      yield SignInedApple();
    } else if (event is SignInApple) {
      yield SignInedApple();
    } else if (event is ShowOrHideTerms) {
      yield TermsIsShownOrHidden();
    }else if (event is CheckFields) {
      yield FieldsChecked();
    }
  }
}
