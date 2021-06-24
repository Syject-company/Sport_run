import 'package:equatable/equatable.dart';

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
