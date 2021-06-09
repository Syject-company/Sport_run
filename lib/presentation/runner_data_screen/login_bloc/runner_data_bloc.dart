import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/runner_data_screen/login_bloc/runner_data_event.dart';
import 'package:one2one_run/presentation/runner_data_screen/login_bloc/runner_data_state.dart';



class RunnerDataBloc extends Bloc<RunnerDataEvents, RunnerDataState> {
  RunnerDataBloc() : super(LoginInitial());

  @override
  Stream<RunnerDataState> mapEventToState(RunnerDataEvents event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    }
  }
}
