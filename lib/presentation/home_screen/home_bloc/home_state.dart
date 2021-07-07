import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class StateUpdated extends HomeState {}

class NavigatedToPage extends HomeState {
  NavigatedToPage({required this.pageIndex});

  final int pageIndex;

  @override
  List<Object> get props => [pageIndex];
}

class UserDataUpdated extends HomeState {}

class SwitchedIsNeedFilter extends HomeState {
  SwitchedIsNeedFilter({required this.isNeedFilter});

  final bool isNeedFilter;

  @override
  List<Object> get props => [isNeedFilter];
}
class KmOrMileIsSelected extends HomeState {
  KmOrMileIsSelected(this.isKM);

  final bool isKM;

  @override
  List<Object> get props => [isKM];
}

class TimesPerWeekIsSelected extends HomeState {
  TimesPerWeekIsSelected(this.timesPerWeek);

  final int timesPerWeek;

  @override
  List<Object> get props => [timesPerWeek];
}

class SelectedConnectFilters extends HomeState {
  SelectedConnectFilters(this.isFilterIncluded, this.paceFrom, this.paceTo,
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