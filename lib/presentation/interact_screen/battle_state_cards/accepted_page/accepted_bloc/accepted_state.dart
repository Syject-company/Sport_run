import 'package:equatable/equatable.dart';

abstract class AcceptedState extends Equatable {
  const AcceptedState();

  @override
  List<Object> get props => <Object>[];
}

class AcceptedInitial extends AcceptedState {}

class StateUpdated extends AcceptedState {}

class ResultBattlePrepared extends AcceptedState {}

class ResultBattleUploaded extends AcceptedState {}

class UploadResultPageShown extends AcceptedState {
  const UploadResultPageShown({required this.isNeedResultPage});

  final bool isNeedResultPage;

  @override
  List<Object> get props => <Object>[isNeedResultPage];
}

class TimePickerOpened extends AcceptedState {}

class GalleryIsOpened extends AcceptedState {}
