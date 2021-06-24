import 'package:equatable/equatable.dart';

abstract class EState extends Equatable {
  const EState();

  @override
  List<Object> get props => [];
}

class EInitial extends EState {}

class StateUpdated extends EState {}



