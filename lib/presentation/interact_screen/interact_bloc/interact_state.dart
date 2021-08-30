import 'package:equatable/equatable.dart';

abstract class InteractState extends Equatable {
  const InteractState();

  @override
  List<Object> get props => <Object>[];
}

class InteractInitial extends InteractState {}

class StateUpdated extends InteractState {}

class BattleIsAccepted extends InteractState {
  const BattleIsAccepted({required this.id});

  final String id;

  @override
  List<Object> get props => <Object>[id];
}

class BattleIsDeclined extends InteractState {
  const BattleIsDeclined({required this.id});

  final String id;

  @override
  List<Object> get props => <Object>[id];
}

class ActivePageUpdated extends InteractState {}



