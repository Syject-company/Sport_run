import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateState extends HomeEvent {}

class NavigateToPage extends HomeEvent {
  NavigateToPage({required this.pageIndex});

  final int pageIndex;

  @override
  List<Object> get props => [pageIndex];
}

class UpdateUserData extends HomeEvent {}

class SwitchIsNeedFilter extends HomeEvent {
  SwitchIsNeedFilter({required this.isNeedFilter});

  final bool isNeedFilter;

  @override
  List<Object> get props => [isNeedFilter];
}

class SelectKmOrMile extends HomeEvent {
  SelectKmOrMile(this.isKM);

  final bool isKM;

  @override
  List<Object> get props => [isKM];
}

class SelectTimesPerWeek extends HomeEvent {
  SelectTimesPerWeek(this.timesPerWeek);

  final int timesPerWeek;

  @override
  List<Object> get props => [timesPerWeek];
}

class SelectConnectFilters extends HomeEvent {
  SelectConnectFilters(this.isFilterIncluded, this.paceFrom, this.paceTo,
      this.weeklyDistanceFrom, this.weeklyDistanceTo, this.workoutsPerWeek);

  final bool isFilterIncluded;
  final double paceFrom;
  final double paceTo;
  final double weeklyDistanceFrom;
  final double weeklyDistanceTo;
  final int workoutsPerWeek;

  @override
  List<Object> get props => [
        isFilterIncluded,
        paceFrom,
        paceTo,
        weeklyDistanceFrom,
        weeklyDistanceTo,
        workoutsPerWeek
      ];
}
