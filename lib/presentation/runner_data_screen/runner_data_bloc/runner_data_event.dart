import 'package:equatable/equatable.dart';
import 'package:one2one_run/data/models/runner_data_model.dart';

abstract class RunnerDataEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateState extends RunnerDataEvents {}

class CheckFields extends RunnerDataEvents {}

class SelectKmOrMile extends RunnerDataEvents {
  SelectKmOrMile(this.isKM);

  final bool isKM;

  @override
  List<Object> get props => [isKM];
}

class SelectTimesPerWeek extends RunnerDataEvents {
  SelectTimesPerWeek(this.timesPerWeek);

  final int timesPerWeek;

  @override
  List<Object> get props => [timesPerWeek];
}

class NavigateToHome extends RunnerDataEvents {
  NavigateToHome(this.runnerDataModel);

  final RunnerDataModel runnerDataModel;

  @override
  List<Object> get props => [runnerDataModel];
}
