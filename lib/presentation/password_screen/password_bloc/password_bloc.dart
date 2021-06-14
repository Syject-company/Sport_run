import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/password_screen/password_bloc/password_event.dart';
import 'package:one2one_run/presentation/password_screen/password_bloc/password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  PasswordBloc() : super(PasswordInitial());

  @override
  Stream<PasswordState> mapEventToState(PasswordEvent event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    } else if (event is ShowOrHidePass) {
      yield PassIsShownOrHidden();
    } else if (event is CheckFields) {
      yield FieldsChecked();
    } else if (event is NavigateToEnterCodePage) {
      yield NavigatedToEnterCodePage();
    } else if (event is ResendCode) {
      yield ResentCode();
    } else if (event is CheckCode) {
      yield CodeIsChecked();
    } else if (event is NavigateToCreateNewPassword) {
      yield NavigatedToCreateNewPassword();
    } else if (event is ShowHideLoading) {
      yield IsShownHiddenLoading();
    } else if (event is ShowCodeError) {
      yield IsShownCodeError();
    }
  }
}
