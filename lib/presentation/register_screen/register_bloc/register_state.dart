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

class SignInedGoogle extends RegisterState {}

class SignInedApple extends RegisterState {}

class TermsIsShownOrHidden extends RegisterState {}

class FieldsChecked extends RegisterState {}
