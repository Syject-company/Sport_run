import 'package:equatable/equatable.dart';
import 'package:one2one_run/data/models/check_opponent_results_model.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';

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

class GalleryIsOpened extends ActiveDetailState {}

class ImageZoomDialogIsOpened extends ActiveDetailState {
  const ImageZoomDialogIsOpened({required this.photos});

  final List<String> photos;

  @override
  List<Object> get props => <Object>[photos];
}

class MessageChatSent extends ActiveDetailState {}

class ChatMessageGot extends ActiveDetailState {
  const ChatMessageGot({required this.messageModel});

  final Messages messageModel;

  @override
  List<Object> get props => <Object>[messageModel];
}

class OpponentResultsDialogOpened extends ActiveDetailState {
  const OpponentResultsDialogOpened({
    required this.model,
  });

  final CheckOpponentResultsModel model;

  @override
  List<Object> get props => <Object>[model];
}

class OpponentResultsChecked extends ActiveDetailState {
  const OpponentResultsChecked({
    required this.isNeed,
  });

  final bool isNeed;

  @override
  List<Object> get props => <Object>[isNeed];
}

class TheTimeResultChanged extends ActiveDetailState {
  const TheTimeResultChanged({
    required this.time,
  });

  final String time;

  @override
  List<Object> get props => <Object>[time];
}
