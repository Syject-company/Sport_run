import 'package:equatable/equatable.dart';

abstract class AcceptedEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateState extends AcceptedEvent {}

class UploadResultBattle extends AcceptedEvent {
  UploadResultBattle({required this.id});

  final String id;

  @override
  List<Object> get props => <Object>[id];
}
