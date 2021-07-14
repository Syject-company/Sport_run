import 'package:equatable/equatable.dart';
import 'package:one2one_run/data/models/connect_users_model.dart';
import 'package:one2one_run/utils/enums.dart';

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

class BattleDrawerIsOpen extends HomeState {
  BattleDrawerIsOpen(this.userModel);

  final ConnectUsersModel userModel;

  @override
  List<Object> get props => [userModel];
}

class FilterDrawerIsOpen extends HomeState {}

class GotDatePicker extends HomeState {}

class MessageDrawerIsOpenOrClose extends HomeState {}

class MessageToOpponentDrawerIsSent extends HomeState {
  MessageToOpponentDrawerIsSent(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class SelectedMessageToOpponent extends HomeState {
  SelectedMessageToOpponent(this.messageIndex);

  final int messageIndex;

  @override
  List<Object> get props => [messageIndex];
}
class BattleCreated extends HomeState {}
