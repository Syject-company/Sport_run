import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateState extends LoginEvent {}

class ShowOrHidePass extends LoginEvent {}

class NavigateToHome extends LoginEvent {}

class NavigateToRegister extends LoginEvent {}

class NavigateToForgotPassword extends LoginEvent {}

class SignInGoogle extends LoginEvent {
  SignInGoogle({required this.token});

  final String token;

  @override
  List<Object> get props => <Object>[token];
}

class SignInApple extends LoginEvent {
  SignInApple({required this.token});

  final String token;

  @override
  List<Object> get props => <Object>[token];
}

class CheckFields extends LoginEvent {}

class NavigateToFAQHelperPage extends LoginEvent {}
