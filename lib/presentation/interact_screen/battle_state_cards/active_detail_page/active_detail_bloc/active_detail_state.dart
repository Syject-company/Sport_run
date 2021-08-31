import 'package:equatable/equatable.dart';

abstract class ActiveDetailState extends Equatable {
  const ActiveDetailState();

  @override
  List<Object> get props => <Object>[];
}

class ActiveDetailInitial extends ActiveDetailState {}

class StateUpdated extends ActiveDetailState {}

class ResultBattlePrepared extends ActiveDetailState {}

class ResultBattleUploaded extends ActiveDetailState {}

class UploadResultPageShown extends ActiveDetailState {
  const UploadResultPageShown({required this.isNeedResultPage});

  final bool isNeedResultPage;

  @override
  List<Object> get props => <Object>[isNeedResultPage];
}

class TimePickerOpened extends ActiveDetailState {}

class GalleryIsOpened extends ActiveDetailState {}

class ImageZoomDialogIsOpened extends ActiveDetailState {
  const ImageZoomDialogIsOpened({required this.photos});

  final List<String> photos;

  @override
  List<Object> get props => <Object>[photos];
}
class MessageChatSent extends ActiveDetailState {}

