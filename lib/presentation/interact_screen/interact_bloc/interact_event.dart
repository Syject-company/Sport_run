import 'package:equatable/equatable.dart';

abstract class InteractEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class UpdateState extends InteractEvent {}