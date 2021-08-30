import 'package:equatable/equatable.dart';

abstract class AcceptedEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateState extends AcceptedEvent {}

class PrepareResultBattle extends AcceptedEvent {}

class UploadResultBattle extends AcceptedEvent {}

class ShowUploadResultPage extends AcceptedEvent {
   ShowUploadResultPage({required this.isNeedResultPage});

  final bool isNeedResultPage;

  @override
  List<Object> get props => <Object>[isNeedResultPage];
}

class OpenTimePicker extends AcceptedEvent {}

class OpenGallery extends AcceptedEvent {}