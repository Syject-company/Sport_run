import 'package:bloc/bloc.dart';
import 'package:one2one_run/_screen/_bloc/e_event.dart';
import 'package:one2one_run/_screen/_bloc/e_state.dart';




class EBloc extends Bloc<EEvent, EState> {
  EBloc() : super(EInitial());

  @override
  Stream<EState> mapEventToState(EEvent event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    }
  }
}
