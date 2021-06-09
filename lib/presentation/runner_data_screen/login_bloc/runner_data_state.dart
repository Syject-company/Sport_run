import 'package:equatable/equatable.dart';

abstract class RunnerDataState extends Equatable {
  const RunnerDataState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends RunnerDataState {}

class StateUpdated extends RunnerDataState {}



