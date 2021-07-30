import 'package:equatable/equatable.dart';

abstract class InteractEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateState extends InteractEvent {}

class AcceptBattle extends InteractEvent {
  AcceptBattle({required this.id});

  final String id;

  @override
  List<Object> get props => <Object>[id];
}

class DeclineBattle extends InteractEvent {
  DeclineBattle({required this.id});

  final String id;

  @override
  List<Object> get props => <Object>[id];
}
