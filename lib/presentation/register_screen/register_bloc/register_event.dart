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

class SignInGoogle extends RegisterEvent {
  SignInGoogle({required this.token});
  final token;

  @override
  List<Object> get props => [token];
}

class SignInApple extends RegisterEvent {
  SignInApple({required this.token});
  final token;

  @override
  List<Object> get props => [token];
}

class ShowOrHideTerms extends RegisterEvent {}

class CheckFields extends RegisterEvent {}
