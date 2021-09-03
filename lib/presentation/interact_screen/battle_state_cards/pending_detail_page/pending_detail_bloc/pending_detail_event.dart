import 'package:equatable/equatable.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';

abstract class PendingDetailEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateState extends PendingDetailEvent {}

class OpenImageZoomDialog extends PendingDetailEvent {
  OpenImageZoomDialog({required this.photos});

  final List<String> photos;

  @override
  List<Object> get props => <Object>[photos];
}

class SendMessageChat extends PendingDetailEvent {}

class GetChatMessage extends PendingDetailEvent {
  GetChatMessage({required this.messageModel});

  final Messages messageModel;

  @override
  List<Object> get props => <Object>[messageModel];
}
