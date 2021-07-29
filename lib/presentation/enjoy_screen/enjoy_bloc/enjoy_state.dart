import 'package:equatable/equatable.dart';

abstract class EnjoyState extends Equatable {
  const EnjoyState();

  @override
  List<Object> get props => <Object>[];
}

class EnjoyInitial extends EnjoyState {}

class StateUpdated extends EnjoyState {}



