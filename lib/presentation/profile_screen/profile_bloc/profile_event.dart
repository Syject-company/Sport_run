import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class UpdateState extends ProfileEvent {}

class OpenGallery extends ProfileEvent {}

class UploadUserPhoto extends ProfileEvent {}
