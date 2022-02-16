import 'package:equatable/equatable.dart';
import 'package:one2one_run/data/models/connect_users_model.dart';

abstract class ConnectEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateState extends ConnectEvent {}

class NavigateToUserInfo extends ConnectEvent {
  NavigateToUserInfo(this.userModel);

  final ConnectUsersModel userModel;

  @override
  List<Object> get props => <Object>[userModel];
}

class StartSearchTheValue extends ConnectEvent {
  StartSearchTheValue(this.value);

  final String value;

  @override
  List<Object> get props => <Object>[value];
}

class ClearSearchTheValue extends ConnectEvent {}
