import 'package:equatable/equatable.dart';
import 'package:one2one_run/data/models/runner_data_model.dart';

abstract class RunnerDataState extends Equatable {
  const RunnerDataState();

  @override
  List<Object> get props => <Object>[];
}

class RunnerDataInitial extends RunnerDataState {}

class StateUpdated extends RunnerDataState {}

class FieldsChecked extends RunnerDataState {}

class KmOrMileIsSelected extends RunnerDataState {
  const KmOrMileIsSelected(this.isKM);

  final bool isKM;

  @override
  List<Object> get props => <Object>[isKM];
}

class TimesPerWeekIsSelected extends RunnerDataState {
  const TimesPerWeekIsSelected(this.timesPerWeek);

  final int timesPerWeek;

  @override
  List<Object> get props => <Object>[timesPerWeek];
}

class ToHomeIsNavigated extends RunnerDataState {
  const ToHomeIsNavigated(this.runnerDataModel);

  final RunnerDataModel runnerDataModel;

  @override
  List<Object> get props => <Object>[runnerDataModel];
}

class RunnerTypeIsSelected extends RunnerDataState {
  const RunnerTypeIsSelected(
      this.isUserBeginnerSelected, this.isUserHaveRunSelected);

  final bool isUserBeginnerSelected;
  final bool isUserHaveRunSelected;

  @override
  List<Object> get props =>
      <Object>[isUserBeginnerSelected, isUserHaveRunSelected];
}
