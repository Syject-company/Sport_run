import 'package:equatable/equatable.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/data/models/connect_users_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => <Object>[];
}

class HomeInitial extends HomeState {}

class StateUpdated extends HomeState {}

class NavigatedToPage extends HomeState {
  const NavigatedToPage({required this.pageIndex});

  final int pageIndex;

  @override
  List<Object> get props => <Object>[pageIndex];
}

class UserDataUpdated extends HomeState {}

class SwitchedIsNeedFilter extends HomeState {
  const SwitchedIsNeedFilter({required this.isNeedFilter});

  final bool isNeedFilter;

  @override
  List<Object> get props => <Object>[isNeedFilter];
}

class TimesPerWeekIsSelected extends HomeState {
  const TimesPerWeekIsSelected(this.timesPerWeek);

  final int timesPerWeek;

  @override
  List<Object> get props => <Object>[timesPerWeek];
}

class SelectedConnectFilters extends HomeState {
  const SelectedConnectFilters(
      this.isFilterIncluded,
      this.paceFrom,
      this.paceTo,
      this.weeklyDistanceFrom,
      this.weeklyDistanceTo,
      this.workoutsPerWeek);

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

class BattleDrawerIsOpen extends HomeState {
  const BattleDrawerIsOpen(this.userModel);

  final ConnectUsersModel userModel;

  @override
  List<Object> get props => <Object>[userModel];
}

class FilterDrawerIsOpen extends HomeState {}

class GotDatePicker extends HomeState {}

class MessageDrawerIsOpenOrClose extends HomeState {}

class MessageToOpponentDrawerIsSent extends HomeState {
  const MessageToOpponentDrawerIsSent(this.message);

  final String message;

  @override
  List<Object> get props => <Object>[message];
}

class SelectedMessageToOpponent extends HomeState {
  const SelectedMessageToOpponent(this.messageIndex);

  final int messageIndex;

  @override
  List<Object> get props => <Object>[messageIndex];
}

class BattleCreated extends HomeState {}

class BattleOnNotificationDrawerIsOpen extends HomeState {
  const BattleOnNotificationDrawerIsOpen(this.model);

  final BattleRespondModel model;

  @override
  List<Object> get props => <Object>[model];
}

class NewConditionsBattleDrawerIsOpenClose extends HomeState {}

class BattleOnNotificationIsAccepted extends HomeState {
  const BattleOnNotificationIsAccepted(this.battleId);

  final String battleId;

  @override
  List<Object> get props => <Object>[battleId];
}

class ApplyBattleIsChanged extends HomeState {
  const ApplyBattleIsChanged(this.battleId);

  final String battleId;

  @override
  List<Object> get props => <Object>[battleId];
}

class ChangeBattleDrawerIsOpened extends HomeState {
  const ChangeBattleDrawerIsOpened(this.battleId, this.model);

  final String battleId;
  final BattleRespondModel model;

  @override
  List<Object> get props => <Object>[battleId, model];
}
