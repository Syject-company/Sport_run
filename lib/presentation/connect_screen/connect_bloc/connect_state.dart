import 'package:equatable/equatable.dart';

abstract class ConnectState extends Equatable {
  const ConnectState();

  @override
  List<Object> get props => [];
}

class ConnectInitial extends ConnectState {}

class StateUpdated extends ConnectState {}



