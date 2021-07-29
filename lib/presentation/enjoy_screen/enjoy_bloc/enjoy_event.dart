import 'package:equatable/equatable.dart';

abstract class EnjoyEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}


class UpdateState extends EnjoyEvent {}