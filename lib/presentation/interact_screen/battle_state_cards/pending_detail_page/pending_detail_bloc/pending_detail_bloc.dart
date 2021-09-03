import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/pending_detail_page/pending_detail_bloc/pending_detail_event.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/pending_detail_page/pending_detail_bloc/pending_detail_state.dart';


class PendingDetailBloc extends Bloc<PendingDetailEvent, PendingDetailState> {
  PendingDetailBloc() : super(PendingDetailInitial());

  @override
  Stream<PendingDetailState> mapEventToState(PendingDetailEvent event) async* {
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
