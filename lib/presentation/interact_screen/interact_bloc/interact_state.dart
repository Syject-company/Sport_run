import 'package:equatable/equatable.dart';

abstract class InteractState extends Equatable {
  const InteractState();

  @override
  List<Object> get props => [];
}

class InteractInitial extends InteractState {}

class StateUpdated extends InteractState {}

class BattleIsAccepted extends InteractState {
  BattleIsAccepted({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

class BattleIsDeclined extends InteractState {
  BattleIsDeclined({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}



