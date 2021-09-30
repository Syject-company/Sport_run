import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/active_detail_page/active_detail_bloc/active_detail_event.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/active_detail_page/active_detail_bloc/active_detail_state.dart';

class ActiveDetailBloc extends Bloc<ActiveDetailEvent, ActiveDetailState> {
  ActiveDetailBloc() : super(ActiveDetailInitial());

  @override
  Stream<ActiveDetailState> mapEventToState(ActiveDetailEvent event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    } else if (event is PrepareResultBattle) {
      yield ResultBattlePrepared();
    } else if (event is ShowUploadResultPage) {
      yield UploadResultPageShown(isNeedResultPage: event.isNeedResultPage);
    } else if (event is OpenGallery) {
      yield GalleryIsOpened();
    } else if (event is UploadResultBattle) {
      yield ResultBattleUploaded();
    } else if (event is OpenImageZoomDialog) {
      yield ImageZoomDialogIsOpened(photos: event.photos);
    } else if (event is SendMessageChat) {
      yield MessageChatSent();
    } else if (event is GetChatMessage) {
      yield ChatMessageGot(messageModel: event.messageModel);
    } else if (event is OpenOpponentResultsDialog) {
      yield OpponentResultsDialogOpened(
        model: event.model,
      );
    } else if (event is IsNeedToCheckOpponentResults) {
      yield OpponentResultsChecked(
        isNeed: event.isNeed,
      );
    } else if (event is ChangeTheTimeResult) {
      yield TheTimeResultChanged(
        time: event.time,
      );
    }
  }
}
