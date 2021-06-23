import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class StateUpdated extends HomeState {}

class NavigatedToPage extends HomeState {
  NavigatedToPage({required this.pageIndex});

  final int pageIndex;

  @override
  List<Object> get props => [pageIndex];
}



