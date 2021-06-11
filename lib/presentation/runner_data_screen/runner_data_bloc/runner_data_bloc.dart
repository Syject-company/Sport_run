import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/runner_data_screen/runner_data_bloc/runner_data_event.dart';
import 'package:one2one_run/presentation/runner_data_screen/runner_data_bloc/runner_data_state.dart';

class RunnerDataBloc extends Bloc<RunnerDataEvents, RunnerDataState> {
  RunnerDataBloc() : super(RunnerDataInitial());

  @override
  Stream<RunnerDataState> mapEventToState(RunnerDataEvents event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    } else if (event is CheckFields) {
      yield FieldsChecked();
    } else if (event is SelectKmOrMile) {
      yield KmOrMileIsSelected(event.isKM);
    } else if (event is SelectTimesPerWeek) {
      yield TimesPerWeekIsSelected(event.timesPerWeek);
    } else if (event is NavigateToHome) {
      yield ToHomeIsNavigated(event.runnerDataModel);
    }
  }
}
