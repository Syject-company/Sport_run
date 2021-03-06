import 'package:equatable/equatable.dart';

abstract class PasswordState extends Equatable {
  const PasswordState();

  @override
  List<Object> get props => <Object>[];
}

class PasswordInitial extends PasswordState {}

class StateUpdated extends PasswordState {}

class PassIsShownOrHidden extends PasswordState {}

class FieldsChecked extends PasswordState {}

class NavigatedToEnterCodePage extends PasswordState {}

class ResentCode extends PasswordState {}

class CodeIsChecked extends PasswordState {}

class NavigatedToCreateNewPassword extends PasswordState {}

class IsShownHiddenLoading extends PasswordState {}

class IsShownCodeError extends PasswordState {}

class NavigatedToLogInPage extends PasswordState {}

class NavigatedToPasswordChangedPage extends PasswordState {}

class FieldsNewPasswordsChecked extends PasswordState {}

class AppBarIsHidden extends PasswordState {}
