import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class StateUpdated extends LoginState {}

class PassIsShownOrHidden extends LoginState {}

class NavigatedToHome extends LoginState {}

class NavigatedToRegister extends LoginState {}

class NavigatedToForgotPassword extends LoginState {}

class SignInedGoogle extends LoginState {
  SignInedGoogle({required this.token});

  final token;

  @override
  List<Object> get props => [token];
}

class SignInedApple extends LoginState {
  SignInedApple({required this.token});

  final token;

  @override
  List<Object> get props => [token];
}

class FieldsChecked extends LoginState {}
