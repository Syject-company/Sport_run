import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateState extends LoginEvent {}

class ShowOrHidePass extends LoginEvent {}

class NavigateToHome extends LoginEvent {}

class NavigateToRegister extends LoginEvent {}

class NavigateToForgotPassword extends LoginEvent {}

class SignInGoogle extends LoginEvent {
  SignInGoogle({required this.token});

  final token;

  @override
  List<Object> get props => [token];
}

class SignInApple extends LoginEvent {
  SignInApple({required this.token});

  final token;

  @override
  List<Object> get props => [token];
}

class CheckFields extends LoginEvent {}
