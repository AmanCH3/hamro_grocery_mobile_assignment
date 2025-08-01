import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/usecase/get_user_usecase.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/usecase/update_profile_picture.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/usecase/update_user_usecase.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/usecase/user_logout_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final GetUserUsecase _getUserUseCase;
  final UserUpdateUsecase _userUpdateUsecase;
  final UpdateProfilePictureUsecase _updateProfilePictureUsecase;
  final UserLogoutUseCase _userLogoutUseCase;

  ProfileViewModel({
    required GetUserUsecase userGetUseCase,
    required UserUpdateUsecase userUpdateUseCase,
    required UpdateProfilePictureUsecase updateProfilePictureUsecase,
    required UserLogoutUseCase userLogoutUseCase,
  }) : _getUserUseCase = userGetUseCase,
       _userUpdateUsecase = userUpdateUseCase,
       _updateProfilePictureUsecase = updateProfilePictureUsecase,
       _userLogoutUseCase = userLogoutUseCase,
       super(ProfileState.initial()) {
    // Register all event handlers
    on<LoadProfileEvent>(_onProfileLoad);
    on<ProfileImagePickedEvent>(_onProfileImagePicked);
    on<UpdateProfileEvent>(_onProfileUpdate);
    on<UpdateProfilePictureEvent>(_onProfilePictureUpdate);
    on<ToggleEditModeEvent>(_onToggleEditMode);
    on<ClearMessageEvent>(_onClearMessage);
    on<LogoutEvent>(_onLogout);
    add(LoadProfileEvent());
  }

  Future<void> _onProfileLoad(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, newProfileImageFile: () => null));
    final result = await _getUserUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: () => failure.message),
      ),
      (user) => emit(
        state.copyWith(isLoading: false, authEntity: user, isEditing: false),
      ),
    );
  }

  /// Updates the state with the image file the user picked from the gallery.
  void _onProfileImagePicked(
    ProfileImagePickedEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(newProfileImageFile: () => event.imageFile));
  }

  /// Handles the "Save" button press. It first updates text fields.
  /// If successful and a new image exists, it triggers the image upload.
  Future<void> _onProfileUpdate(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _userUpdateUsecase(event.authEntity);

    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: () => failure.message),
      ),
      (updatedUser) {
        final imageToUpload = state.newProfileImageFile;
        // If an image was picked, chain the next event to upload it.
        if (imageToUpload != null) {
          // Update the user data in the state but keep loading.
          emit(state.copyWith(authEntity: updatedUser));
          add(UpdateProfilePictureEvent(imageFile: imageToUpload));
        } else {
          // If no new image, the process is complete.
          emit(
            state.copyWith(
              isLoading: false,
              authEntity: updatedUser,
              isEditing: false, // Turn off editing mode
              errorMessage: () => 'Profile updated successfully!',
            ),
          );
        }
      },
    );
  }

  /// Handles the actual profile picture upload. This is typically called by _onProfileUpdate.
  Future<void> _onProfilePictureUpdate(
    UpdateProfilePictureEvent event,
    Emitter<ProfileState> emit,
  ) async {
    // The state should already be loading.
    final result = await _updateProfilePictureUsecase(event.imageFile);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: () => failure.message),
      ),
      // On success, the entire update process is finished.
      (updatedUser) => emit(
        state.copyWith(
          isLoading: false,
          authEntity: updatedUser,
          isEditing: false, // Turn off editing mode
          errorMessage: () => 'Profile updated successfully!',
          // IMPORTANT: Clear the picked image file to show the new network image.
          newProfileImageFile: () => null,
        ),
      ),
    );
  }

  /// Toggles the UI between view mode and edit mode.
  void _onToggleEditMode(
    ToggleEditModeEvent event,
    Emitter<ProfileState> emit,
  ) {
    // If exiting edit mode, clear any unsaved image preview.
    if (state.isEditing) {
      emit(
        state.copyWith(
          isEditing: !state.isEditing,
          newProfileImageFile: () => null,
        ),
      );
    } else {
      emit(state.copyWith(isEditing: !state.isEditing));
    }
  }

  /// Clears any message from the state, used after a SnackBar is shown.
  void _onClearMessage(ClearMessageEvent event, Emitter<ProfileState> emit) {
    emit(state.copyWith(errorMessage: () => null));
  }

  /// Handles user logout.
  Future<void> _onLogout(LogoutEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _userLogoutUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: () => failure.message),
      ),
      (success) => emit(state.copyWith(isLoading: false, isLoggedOut: true)),
    );
  }
}
