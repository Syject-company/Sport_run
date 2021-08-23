import 'package:equatable/equatable.dart';

abstract class AcceptedState extends Equatable {
  const AcceptedState();

  @override
  List<Object> get props => <Object>[];
}

class AcceptedInitial extends AcceptedState {}

class StateUpdated extends AcceptedState {}

class ResultBattleUploaded extends AcceptedState {
  const ResultBattleUploaded({required this.id});

  final String id;

  @override
  List<Object> get props => <Object>[id];
}
