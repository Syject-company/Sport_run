import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => <Object>[];
}

class ProfileInitial extends ProfileState {}

class StateUpdated extends ProfileState {}

class GalleryIsOpened extends ProfileState {}

class UserPhotoUploaded extends ProfileState {}

