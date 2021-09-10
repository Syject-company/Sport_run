import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/finished_completed_detail_page/finished_completed_detail_bloc/finished_completed_detail_event.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/finished_completed_detail_page/finished_completed_detail_bloc/finished_completed_detail_state.dart';

class FinishedCompletedDetailBloc
    extends Bloc<FinishedCompletedDetailEvent, FinishedCompletedDetailState> {
  FinishedCompletedDetailBloc() : super(FinishedCompletedDetailInitial());

  @override
  Stream<FinishedCompletedDetailState> mapEventToState(
      FinishedCompletedDetailEvent event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    } else if (event is OpenImageZoomDialog) {
      yield ImageZoomDialogIsOpened(photos: event.photos);
    } else if (event is SendMessageChat) {
      yield MessageChatSent();
    } else if (event is GetChatMessage) {
      yield ChatMessageGot(messageModel: event.messageModel);
    }else if (event is ShareImageBattle) {
      yield ImageBattleIsShared();
    }
  }
}
