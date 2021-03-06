import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/interact_screen/interact_bloc/interact_event.dart';
import 'package:one2one_run/presentation/interact_screen/interact_bloc/interact_state.dart';


class InteractBloc extends Bloc<InteractEvent, InteractState> {
  InteractBloc() : super(InteractInitial());

  @override
  Stream<InteractState> mapEventToState(InteractEvent event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    }else if (event is AcceptBattle) {
      yield BattleIsAccepted(id: event.id,isNegotiate: event.isNegotiate);
    }else if (event is DeclineBattle) {
      yield BattleIsDeclined(id: event.id);
    }else if (event is UpdateActivePage) {
      yield ActivePageUpdated();
    }
  }
}
