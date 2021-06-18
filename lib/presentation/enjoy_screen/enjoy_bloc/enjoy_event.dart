import 'package:equatable/equatable.dart';

abstract class EnjoyEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class UpdateState extends EnjoyEvent {}