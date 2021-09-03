import 'package:equatable/equatable.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';

abstract class PendingDetailState extends Equatable {
  const PendingDetailState();

  @override
  List<Object> get props => <Object>[];
}

class PendingDetailInitial extends PendingDetailState {}

class StateUpdated extends PendingDetailState {}

class ImageZoomDialogIsOpened extends PendingDetailState {
  const ImageZoomDialogIsOpened({required this.photos});

  final List<String> photos;

  @override
  List<Object> get props => <Object>[photos];
}

class MessageChatSent extends PendingDetailState {}

class ChatMessageGot extends PendingDetailState {
  const ChatMessageGot({required this.messageModel});

  final Messages messageModel;

  @override
  List<Object> get props => <Object>[messageModel];
}
