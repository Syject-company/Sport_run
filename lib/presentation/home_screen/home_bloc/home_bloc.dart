import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/home_screen/home_bloc/home_event.dart';
import 'package:one2one_run/presentation/home_screen/home_bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    } else if (event is NavigateToPage) {
      yield NavigatedToPage(pageIndex: event.pageIndex);
    } else if (event is UpdateUserData) {
      yield UserDataUpdated();
    } else if (event is SwitchIsNeedFilter) {
      yield SwitchedIsNeedFilter(isNeedFilter: event.isNeedFilter);
    } else if (event is SelectTimesPerWeek) {
      yield TimesPerWeekIsSelected(event.timesPerWeek);
    } else if (event is SelectConnectFilters) {
      yield SelectedConnectFilters(
          event.isFilterIncluded,
          event.paceFrom,
          event.paceTo,
          event.weeklyDistanceFrom,
          event.weeklyDistanceTo,
          event.workoutsPerWeek);
    } else if (event is OpenBattleDrawer) {
      yield BattleDrawerIsOpen(event.userModel);
    } else if (event is OpenFilterDrawer) {
      yield FilterDrawerIsOpen();
    } else if (event is GetDatePicker) {
      yield GotDatePicker();
    } else if (event is OpenCloseMessageDrawer) {
      yield MessageDrawerIsOpenOrClose();
    } else if (event is SendMessageToOpponent) {
      yield MessageToOpponentDrawerIsSent(event.message);
    } else if (event is SelectMessageToOpponent) {
      yield SelectedMessageToOpponent(event.messageIndex);
    } else if (event is CreateBattle) {
      yield BattleCreated();
    } else if (event is OpenBattleOnNotificationDrawer) {
      yield BattleOnNotificationDrawerIsOpen(event.model);
    } else if (event is OpenCloseNewConditionsBattleDrawer) {
      yield NewConditionsBattleDrawerIsOpenClose();
    } else if (event is AcceptBattleOnNotification) {
      yield BattleOnNotificationIsAccepted(event.battleId);
    } else if (event is ApplyBattleChanges) {
      yield ApplyBattleIsChanged(event.battleId);
    } else if (event is OpenChangeBattleDrawer) {
      yield ChangeBattleDrawerIsOpened(event.battleId, event.model);
    } else if (event is ChangeFilterRangePace) {
      yield FilterRangePaceChanged(event.values);
    }else if (event is ChangeFilterRangeWeekly) {
      yield FilterRangeWeeklyChanged(event.values);
    }else if (event is ChangeDistanceValue) {
      yield DistanceValueChanged(event.value);
    }else if (event is ChangeDropMenuDistanceValue) {
      yield DropMenuDistanceValueChanged(event.value);
    }else if (event is ShowHideSearchBar) {
      yield SearchBarShownHidden();
    }else if (event is ChangeAcceptVisibleButton) {
      yield AcceptNeedToVisibleFromNotification(event.battleId);
    }
  }
}
