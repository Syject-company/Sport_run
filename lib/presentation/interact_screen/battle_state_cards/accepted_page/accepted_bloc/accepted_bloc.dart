import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/accepted_page/accepted_bloc/accepted_event.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/accepted_page/accepted_bloc/accepted_state.dart';

class AcceptedBloc extends Bloc<AcceptedEvent, AcceptedState> {
  AcceptedBloc() : super(AcceptedInitial());

  @override
  Stream<AcceptedState> mapEventToState(AcceptedEvent event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    } else if (event is UploadResultBattle) {
      yield ResultBattleUploaded(id: event.id);
    }
  }
}
