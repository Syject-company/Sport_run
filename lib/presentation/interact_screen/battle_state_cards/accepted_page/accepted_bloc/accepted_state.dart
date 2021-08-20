import 'package:equatable/equatable.dart';

abstract class AcceptedState extends Equatable {
  const AcceptedState();

  @override
  List<Object> get props => <Object>[];
}

class AcceptedInitial extends AcceptedState {}

class StateUpdated extends AcceptedState {}



