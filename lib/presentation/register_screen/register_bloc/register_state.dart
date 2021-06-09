import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class StateUpdated extends RegisterState {}

class PassIsShownOrHidden extends RegisterState {}

class NavigatedToRunnersData extends RegisterState {}

class NavigatedToSignIn extends RegisterState {}

class TermsIsAccepted extends RegisterState {}

class SignInedGoogle extends RegisterState {
  SignInedGoogle({required this.token});
  final token;

  @override
  List<Object> get props => [token];
}

class SignInedApple extends RegisterState {
  SignInedApple({required this.token});
  final token;

  @override
  List<Object> get props => [token];
}

class TermsIsShownOrHidden extends RegisterState {}

class FieldsChecked extends RegisterState {}
