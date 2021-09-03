import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/finished_discarded_detail_page/finished_discarded_detail_bloc/finished_discarded_detail_event.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/finished_discarded_detail_page/finished_discarded_detail_bloc/finished_discarded_detail_state.dart';

class FinishedDiscardedDetailBloc
    extends Bloc<FinishedDiscardedDetailEvent, FinishedDiscardedDetailState> {
  FinishedDiscardedDetailBloc() : super(FinishedDiscardedDetailInitial());

  @override
  Stream<FinishedDiscardedDetailState> mapEventToState(
      FinishedDiscardedDetailEvent event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    } else if (event is OpenImageZoomDialog) {
      yield ImageZoomDialogIsOpened(photos: event.photos);
    } else if (event is SendMessageChat) {
      yield MessageChatSent();
    } else if (event is GetChatMessage) {
      yield ChatMessageGot(messageModel: event.messageModel);
    }
  }
}
