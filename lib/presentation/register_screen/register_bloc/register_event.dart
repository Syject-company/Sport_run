import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateState extends RegisterEvent {}

class ShowOrHidePass extends RegisterEvent {}

class NavigateToRunnersData extends RegisterEvent {}

class NavigateToSignIn extends RegisterEvent {}

class AcceptTerms extends RegisterEvent {}
class AcceptPrivacy extends RegisterEvent {}

class SignInGoogle extends RegisterEvent {
  SignInGoogle({required this.token});

  final String token;

  @override
  List<Object> get props => <Object>[token];
}

class SignInApple extends RegisterEvent {
  SignInApple({required this.token});

  final String token;

  @override
  List<Object> get props => <Object>[token];
}

class ShowOrHideTerms extends RegisterEvent {}
class ShowOrHidePrivacy extends RegisterEvent {}

class CheckFields extends RegisterEvent {}
