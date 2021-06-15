import 'package:equatable/equatable.dart';

abstract class PasswordEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateState extends PasswordEvent {}

class ShowOrHidePass extends PasswordEvent {}

class CheckFields extends PasswordEvent {}

class NavigateToEnterCodePage extends PasswordEvent {}

class ResendCode extends PasswordEvent {}

class CheckCode extends PasswordEvent {}

class NavigateToCreateNewPassword extends PasswordEvent {}

class ShowHideLoading extends PasswordEvent {}

class ShowCodeError extends PasswordEvent {}

class NavigateToLogInPage extends PasswordEvent {}

class CheckNewPasswordsFields extends PasswordEvent {}

class NavigateToPasswordChangedPage extends PasswordEvent {}

class HideAppBar extends PasswordEvent {}