import 'package:equatable/equatable.dart';

abstract class ConnectEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class UpdateState extends ConnectEvent {}