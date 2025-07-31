import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/usecase/get_user_usecase.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/usecase/update_profile_picture.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/usecase/update_user_usecase.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/usecase/user_logout_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final GetUserUsecase _userGetUseCase;
  final UserUpdateUsecase _userUpdateUsecase;
  final UpdateProfilePictureUsecase _updateProfilePictureUsecase;
  final UserLogoutUseCase _userLogoutUseCase;

  ProfileViewModel({
    required GetUserUsecase userGetUseCase,
    required UserUpdateUsecase userUpdateUseCase,
    required UpdateProfilePictureUsecase updateProfilePictureUsecase,
    required UserLogoutUseCase userLogoutUseCase,
  }) : _userGetUseCase = userGetUseCase,
       _userUpdateUsecase = userUpdateUseCase,
       _updateProfilePictureUsecase = updateProfilePictureUsecase,
       _userLogoutUseCase = userLogoutUseCase,
       super(ProfileState.initial()) {
    on<LoadProfileEvent>(_onProfileLoad);
    on<UpdateProfileEvent>(_onProfileUpdate);
    on<UpdateProfilePictureEvent>(_onProfilePictureUpdate);
    on<ToggleEditModeEvent>(_onToggleEditMode);
    on<ClearMessageEvent>(_onClearMessage);
    on<ProfileImagePickedEvent>(_onProfileImagePicked);
    on<LogoutEvent>(_onLogout);

    add(LoadProfileEvent());
  }

  Future<void> _onProfileLoad(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, newProfileImageFile: () => null));
    final result = await _userGetUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: () => failure.message),
      ),
      (user) => emit(
        state.copyWith(isLoading: false, authEntity: user, isEditing: false),
      ),
    );
  }

  void _onProfileImagePicked(
    ProfileImagePickedEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(newProfileImageFile: () => event.imageFile));
  }

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
        // If no new image is being uploaded, we can stop editing and show success.
        final bool shouldStopEditing = state.newProfileImageFile == null;
        emit(
          state.copyWith(
            isLoading: false,
            authEntity: updatedUser,
            isEditing: !shouldStopEditing,
            errorMessage:
                () =>
                    shouldStopEditing ? 'Profile updated successfully!' : null,
          ),
        );
      },
    );
  }

  Future<void> _onProfilePictureUpdate(
    UpdateProfilePictureEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _updateProfilePictureUsecase(event.imageFile);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: () => failure.message),
      ),
      (updatedUser) => emit(
        state.copyWith(
          isLoading: false,
          authEntity: updatedUser,
          isEditing: false, // Turn off editing mode
          errorMessage: () => 'Profile updated successfully!',
          newProfileImageFile: () => null, // Clear the picked image
        ),
      ),
    );
  }

  void _onToggleEditMode(
    ToggleEditModeEvent event,
    Emitter<ProfileState> emit,
  ) {
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

  void _onClearMessage(ClearMessageEvent event, Emitter<ProfileState> emit) {
    emit(state.copyWith(errorMessage: () => null));
  }

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
