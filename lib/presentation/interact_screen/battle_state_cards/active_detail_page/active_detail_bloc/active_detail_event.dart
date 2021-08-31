import 'package:equatable/equatable.dart';

abstract class ActiveDetailEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateState extends ActiveDetailEvent {}

class PrepareResultBattle extends ActiveDetailEvent {}

class UploadResultBattle extends ActiveDetailEvent {}

class ShowUploadResultPage extends ActiveDetailEvent {
  ShowUploadResultPage({required this.isNeedResultPage});

  final bool isNeedResultPage;

  @override
  List<Object> get props => <Object>[isNeedResultPage];
}

class OpenTimePicker extends ActiveDetailEvent {}

class OpenGallery extends ActiveDetailEvent {}

class OpenImageZoomDialog extends ActiveDetailEvent {
  OpenImageZoomDialog({required this.photos});

  final List<String> photos;

  @override
  List<Object> get props => <Object>[photos];
}

class SendMessageChat extends ActiveDetailEvent {}
