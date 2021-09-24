import 'package:bloc/bloc.dart';
import 'package:one2one_run/presentation/edit_profile_screen/edit_profile_bloc/edit_profile_event.dart';
import 'package:one2one_run/presentation/edit_profile_screen/edit_profile_bloc/edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitial());

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is UpdateState) {
      yield StateUpdated();
    } else if (event is SelectKmOrMile) {
      yield KmOrMileIsSelected(event.isKM);
    } else if (event is SelectTimesPerWeek) {
      yield TimesPerWeekIsSelected(event.timesPerWeek);
    }else if (event is SaveUserData) {
      yield UserDataSaved();
    }else if (event is ChangeDistanceValue) {
      yield DistanceValueChanged(event.value);
    }else if (event is ChangePaceValue) {
      yield PaceValueChanged(event.value);
    }
  }
}
