import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateState extends RegisterEvent {}

class ShowOrHidePass extends RegisterEvent {}

class NavigateToRunnersData extends RegisterEvent {}

class NavigateToSignIn extends RegisterEvent {}

class AcceptTerms extends RegisterEvent {}

class SignInGoogle extends RegisterEvent {}

class SignInApple extends RegisterEvent {}

class ShowOrHideTerms extends RegisterEvent {}

class CheckFields extends RegisterEvent {}
