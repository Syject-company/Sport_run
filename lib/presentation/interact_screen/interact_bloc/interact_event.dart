import 'package:equatable/equatable.dart';

abstract class InteractEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateState extends InteractEvent {}

class AcceptBattle extends InteractEvent {
  AcceptBattle({required this.id, required this.isNegotiate});

  final String id;
  final bool isNegotiate;

  @override
  List<Object> get props => <Object>[id, isNegotiate];
}

class DeclineBattle extends InteractEvent {
  DeclineBattle({required this.id});

  final String id;

  @override
  List<Object> get props => <Object>[id];
}

class UpdateActivePage extends InteractEvent {}
