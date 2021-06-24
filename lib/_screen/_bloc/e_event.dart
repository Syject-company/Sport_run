import 'package:equatable/equatable.dart';

abstract class EEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class UpdateState extends EEvent {}