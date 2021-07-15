import 'package:equatable/equatable.dart';
import 'package:one2one_run/data/models/connect_users_model.dart';
import 'package:one2one_run/utils/enums.dart';

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

class OpenBattleDrawer extends HomeEvent {
  OpenBattleDrawer(this.userModel);

  final ConnectUsersModel userModel;

  @override
  List<Object> get props => [userModel];
}

class OpenFilterDrawer extends HomeEvent {}

class GetDatePicker extends HomeEvent {}

class OpenCloseMessageDrawer extends HomeEvent {}

class SendMessageToOpponent extends HomeEvent {
  SendMessageToOpponent(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class SelectMessageToOpponent extends HomeEvent {
  SelectMessageToOpponent(this.messageIndex);

  final int messageIndex;

  @override
  List<Object> get props => [messageIndex];
}

class CreateBattle extends HomeEvent {}