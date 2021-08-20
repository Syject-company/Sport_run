import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/enjoy_screen/enjoy_bloc/enjoy_event.dart';
import 'package:one2one_run/presentation/enjoy_screen/enjoy_bloc/enjoy_state.dart';



class AcceptedBloc extends Bloc<EnjoyEvent, EnjoyState> {
  AcceptedBloc() : super(EnjoyInitial());

  @override
  Stream<EnjoyState> mapEventToState(EnjoyEvent event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    }
  }
}
