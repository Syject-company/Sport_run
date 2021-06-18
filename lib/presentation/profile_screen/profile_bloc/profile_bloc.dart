import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/profile_screen/profile_bloc/profile_event.dart';
import 'package:one2one_run/presentation/profile_screen/profile_bloc/profile_state.dart';




class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    }
  }
}
