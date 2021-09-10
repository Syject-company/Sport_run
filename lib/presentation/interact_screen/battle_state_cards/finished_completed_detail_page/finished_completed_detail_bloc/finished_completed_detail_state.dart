import 'package:equatable/equatable.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';

abstract class FinishedCompletedDetailState extends Equatable {
  const FinishedCompletedDetailState();

  @override
  List<Object> get props => <Object>[];
}

class FinishedCompletedDetailInitial extends FinishedCompletedDetailState {}

class StateUpdated extends FinishedCompletedDetailState {}

class ImageZoomDialogIsOpened extends FinishedCompletedDetailState {
  const ImageZoomDialogIsOpened({required this.photos});

  final List<String> photos;

  @override
  List<Object> get props => <Object>[photos];
}

class MessageChatSent extends FinishedCompletedDetailState {}

class ChatMessageGot extends FinishedCompletedDetailState {
  const ChatMessageGot({required this.messageModel});

  final Messages messageModel;

  @override
  List<Object> get props => <Object>[messageModel];
}

class ImageBattleIsShared extends FinishedCompletedDetailState {}
