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
    }
  }
}
