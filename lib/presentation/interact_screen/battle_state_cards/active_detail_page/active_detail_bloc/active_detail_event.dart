import 'package:equatable/equatable.dart';
import 'package:one2one_run/data/models/check_opponent_results_model.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';

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

class OpenGallery extends ActiveDetailEvent {}

class OpenImageZoomDialog extends ActiveDetailEvent {
  OpenImageZoomDialog({required this.photos});

  final List<String> photos;

  @override
  List<Object> get props => <Object>[photos];
}

class SendMessageChat extends ActiveDetailEvent {}

class GetChatMessage extends ActiveDetailEvent {
  GetChatMessage({required this.messageModel});

  final Messages messageModel;

  @override
  List<Object> get props => <Object>[messageModel];
}

class OpenOpponentResultsDialog extends ActiveDetailEvent {
  OpenOpponentResultsDialog({
    required this.model,
  });

  final CheckOpponentResultsModel model;

  @override
  List<Object> get props => <Object>[model];
}

class IsNeedToCheckOpponentResults extends ActiveDetailEvent {
  IsNeedToCheckOpponentResults({
    required this.isNeed,
  });

  final bool isNeed;

  @override
  List<Object> get props => <Object>[isNeed];
}

class ChangeTheTimeResult extends ActiveDetailEvent {
  ChangeTheTimeResult({
    required this.time,
  });

  final String time;

  @override
  List<Object> get props => <Object>[time];
}
