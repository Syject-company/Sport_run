import 'package:equatable/equatable.dart';
import 'package:one2one_run/data/models/connect_users_model.dart';

abstract class ConnectState extends Equatable {
  const ConnectState();

  @override
  List<Object> get props => [];
}

class ConnectInitial extends ConnectState {}

class StateUpdated extends ConnectState {}

class NavigatedToUserInfo extends ConnectState {
  NavigatedToUserInfo(this.userModel);

  final ConnectUsersModel userModel;

  @override
  List<Object> get props => [userModel];
}
