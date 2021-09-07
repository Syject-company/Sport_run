import 'package:equatable/equatable.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';

abstract class FinishedCompletedDetailEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateState extends FinishedCompletedDetailEvent {}

class OpenImageZoomDialog extends FinishedCompletedDetailEvent {
  OpenImageZoomDialog({required this.photos});

  final List<String> photos;

  @override
  List<Object> get props => <Object>[photos];
}

class SendMessageChat extends FinishedCompletedDetailEvent {}

class GetChatMessage extends FinishedCompletedDetailEvent {
  GetChatMessage({required this.messageModel});

  final Messages messageModel;

  @override
  List<Object> get props => <Object>[messageModel];
}
