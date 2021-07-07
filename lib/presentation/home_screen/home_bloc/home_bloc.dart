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
    } else if (event is SelectKmOrMile) {
      yield KmOrMileIsSelected(event.isKM);
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
    }
  }
}
