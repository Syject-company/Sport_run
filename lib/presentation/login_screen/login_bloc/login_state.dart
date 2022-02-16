import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => <Object>[];
}

class LoginInitial extends LoginState {}

class StateUpdated extends LoginState {}

class PassIsShownOrHidden extends LoginState {}

class NavigatedToHome extends LoginState {}

class NavigatedToRegister extends LoginState {}

class NavigatedToForgotPassword extends LoginState {}

class SignInedGoogle extends LoginState {
  const SignInedGoogle({required this.token});

  final String token;

  @override
  List<Object> get props => <Object>[token];
}

class SignInedApple extends LoginState {
  const SignInedApple({required this.token});

  final String token;

  @override
  List<Object> get props => <Object>[token];
}

class FieldsChecked extends LoginState {}

class NavigatedToFAQHelperPage extends LoginState {}
