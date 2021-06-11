import 'package:equatable/equatable.dart';
import 'package:one2one_run/data/models/runner_data_model.dart';

abstract class RunnerDataState extends Equatable {
  const RunnerDataState();

  @override
  List<Object> get props => [];
}

class RunnerDataInitial extends RunnerDataState {}

class StateUpdated extends RunnerDataState {}

class FieldsChecked extends RunnerDataState {}

class KmOrMileIsSelected extends RunnerDataState {
  KmOrMileIsSelected(this.isKM);

  final bool isKM;

  @override
  List<Object> get props => [isKM];
}

class TimesPerWeekIsSelected extends RunnerDataState {
  TimesPerWeekIsSelected(this.timesPerWeek);

  final int timesPerWeek;

  @override
  List<Object> get props => [timesPerWeek];
}

class ToHomeIsNavigated extends RunnerDataState {
  ToHomeIsNavigated(this.runnerDataModel);

  final RunnerDataModel runnerDataModel;

  @override
  List<Object> get props => [runnerDataModel];
}
