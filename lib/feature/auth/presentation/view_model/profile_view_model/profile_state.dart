// feature/auth/presentation/view_model/profile_view_model/profile_state.dart

import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/entity/auth_entity.dart';

class ProfileState extends Equatable {
  final AuthEntity? authEntity;
  final bool isLoading;
  final bool isEditing;
  final String? errorMessage;
  final File? newProfileImageFile;
  final bool isLoggedOut;

  const ProfileState({
    this.authEntity,
    required this.isLoading,
    required this.isEditing,
    this.errorMessage,
    this.newProfileImageFile,
    required this.isLoggedOut,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      authEntity: null,
      isLoading: false,
      isEditing: false,
      errorMessage: null,
      newProfileImageFile: null,
      isLoggedOut: false,
    );
  }

  ProfileState copyWith({
    AuthEntity? authEntity,
    bool? isLoading,
    bool? isEditing,
    String? Function()? errorMessage,
    File? Function()? newProfileImageFile,
    bool? isLoggedOut,
  }) {
    return ProfileState(
      authEntity: authEntity ?? this.authEntity,
      isLoading: isLoading ?? this.isLoading,
      isEditing: isEditing ?? this.isEditing,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      newProfileImageFile:
          newProfileImageFile != null
              ? newProfileImageFile()
              : this.newProfileImageFile,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
    );
  }

  @override
  List<Object?> get props => [
    authEntity,
    isLoading,
    isEditing,
    errorMessage,
    newProfileImageFile,
    isLoggedOut,
  ];
}
