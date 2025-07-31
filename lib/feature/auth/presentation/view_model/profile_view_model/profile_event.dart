import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/entity/auth_entity.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class ClearMessageEvent extends ProfileEvent {}

class ToggleEditModeEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class ProfileImagePickedEvent extends ProfileEvent {
  final File imageFile;
  const ProfileImagePickedEvent({required this.imageFile});
  @override
  List<Object?> get props => [imageFile];
}

class UpdateProfileEvent extends ProfileEvent {
  final AuthEntity authEntity;
  const UpdateProfileEvent({required this.authEntity});

  @override
  List<Object?> get props => [authEntity];
}

class LogoutEvent extends ProfileEvent {}

class UpdateProfilePictureEvent extends ProfileEvent {
  final File imageFile;
  const UpdateProfilePictureEvent({required this.imageFile});
  @override
  List<Object?> get props => [imageFile];
}
