import 'package:equatable/equatable.dart';

abstract class AcceptedEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}


class UpdateState extends AcceptedEvent {}