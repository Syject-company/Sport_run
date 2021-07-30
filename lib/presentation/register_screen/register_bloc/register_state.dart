import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => <Object>[];
}

class RegisterInitial extends RegisterState {}

class StateUpdated extends RegisterState {}

class PassIsShownOrHidden extends RegisterState {}

class NavigatedToRunnersData extends RegisterState {}

class NavigatedToSignIn extends RegisterState {}

class TermsIsAccepted extends RegisterState {}

class SignInedGoogle extends RegisterState {
  const SignInedGoogle({required this.token});

  final String token;

  @override
  List<Object> get props => <Object>[token];
}

class SignInedApple extends RegisterState {
  const SignInedApple({required this.token});

  final String token;

  @override
  List<Object> get props => <Object>[token];
}

class TermsIsShownOrHidden extends RegisterState {}

class FieldsChecked extends RegisterState {}
