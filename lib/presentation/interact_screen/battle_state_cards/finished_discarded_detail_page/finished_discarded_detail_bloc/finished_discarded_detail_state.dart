import 'package:equatable/equatable.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';

abstract class FinishedDiscardedDetailState extends Equatable {
  const FinishedDiscardedDetailState();

  @override
  List<Object> get props => <Object>[];
}

class FinishedDiscardedDetailInitial extends FinishedDiscardedDetailState {}

class StateUpdated extends FinishedDiscardedDetailState {}

class ImageZoomDialogIsOpened extends FinishedDiscardedDetailState {
  const ImageZoomDialogIsOpened({required this.photos});

  final List<String> photos;

  @override
  List<Object> get props => <Object>[photos];
}

class MessageChatSent extends FinishedDiscardedDetailState {}

class ChatMessageGot extends FinishedDiscardedDetailState {
  const ChatMessageGot({required this.messageModel});

  final Messages messageModel;

  @override
  List<Object> get props => <Object>[messageModel];
}
