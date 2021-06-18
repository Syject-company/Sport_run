import 'package:equatable/equatable.dart';

abstract class InteractState extends Equatable {
  const InteractState();

  @override
  List<Object> get props => [];
}

class InteractInitial extends InteractState {}

class StateUpdated extends InteractState {}



