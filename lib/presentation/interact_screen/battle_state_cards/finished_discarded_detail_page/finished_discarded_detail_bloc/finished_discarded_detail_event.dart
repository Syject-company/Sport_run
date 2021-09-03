import 'package:equatable/equatable.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';

abstract class FinishedDiscardedDetailEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateState extends FinishedDiscardedDetailEvent {}

class OpenImageZoomDialog extends FinishedDiscardedDetailEvent {
  OpenImageZoomDialog({required this.photos});

  final List<String> photos;

  @override
  List<Object> get props => <Object>[photos];
}

class SendMessageChat extends FinishedDiscardedDetailEvent {}

class GetChatMessage extends FinishedDiscardedDetailEvent {
  GetChatMessage({required this.messageModel});

  final Messages messageModel;

  @override
  List<Object> get props => <Object>[messageModel];
}
