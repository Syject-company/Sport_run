import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/data/models/connect_users_model.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateState extends HomeEvent {}

class NavigateToPage extends HomeEvent {
  NavigateToPage({required this.pageIndex});

  final int pageIndex;

  @override
  List<Object> get props => <Object>[pageIndex];
}

class UpdateUserData extends HomeEvent {}

class SwitchIsNeedFilter extends HomeEvent {
  SwitchIsNeedFilter({required this.isNeedFilter});

  final bool isNeedFilter;

  @override
  List<Object> get props => <Object>[isNeedFilter];
}

class SelectTimesPerWeek extends HomeEvent {
  SelectTimesPerWeek(this.timesPerWeek);

  final int timesPerWeek;

  @override
  List<Object> get props => <Object>[timesPerWeek];
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
  List<Object> get props => <Object>[
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
  List<Object> get props => <Object>[userModel];
}

class OpenFilterDrawer extends HomeEvent {}

class GetDatePicker extends HomeEvent {}

class OpenCloseMessageDrawer extends HomeEvent {}

class SendMessageToOpponent extends HomeEvent {
  SendMessageToOpponent(this.message);

  final String message;

  @override
  List<Object> get props => <Object>[message];
}

class SelectMessageToOpponent extends HomeEvent {
  SelectMessageToOpponent(this.messageIndex);

  final int messageIndex;

  @override
  List<Object> get props => <Object>[messageIndex];
}

class CreateBattle extends HomeEvent {}

class OpenBattleOnNotificationDrawer extends HomeEvent {
  OpenBattleOnNotificationDrawer(this.model);

  final BattleRespondModel model;

  @override
  List<Object> get props => <Object>[model];
}

class OpenCloseNewConditionsBattleDrawer extends HomeEvent {}

class AcceptBattleOnNotification extends HomeEvent {
  AcceptBattleOnNotification(this.battleId);

  final String battleId;

  @override
  List<Object> get props => <Object>[battleId];
}

class ApplyBattleChanges extends HomeEvent {
  ApplyBattleChanges(this.battleId);

  final String battleId;

  @override
  List<Object> get props => <Object>[battleId];
}

class OpenChangeBattleDrawer extends HomeEvent {
  OpenChangeBattleDrawer(this.battleId, this.model);

  final String battleId;
  final BattleRespondModel model;

  @override
  List<Object> get props => <Object>[battleId, model];
}

class ChangeAcceptVisibleButton extends HomeEvent{
  ChangeAcceptVisibleButton(this.battleId, this.model);

  final String battleId;
  final BattleRespondModel model;
  @override
  List<Object> get props => <Object>[battleId, model];

}

class ChangeFilterRangePace extends HomeEvent {
  ChangeFilterRangePace(this.values);

  final RangeValues values;

  @override
  List<Object> get props => <Object>[values];
}

class ChangeFilterRangeWeekly extends HomeEvent {
  ChangeFilterRangeWeekly(this.values);

  final RangeValues values;

  @override
  List<Object> get props => <Object>[values];
}

class ChangeDistanceValue extends HomeEvent {
  ChangeDistanceValue(this.value);

  final double value;

  @override
  List<Object> get props => <Object>[value];
}

class ChangeDropMenuDistanceValue extends HomeEvent {
  ChangeDropMenuDistanceValue(this.value);

  final String value;

  @override
  List<Object> get props => <Object>[value];
}

class ShowHideSearchBar extends HomeEvent {}
