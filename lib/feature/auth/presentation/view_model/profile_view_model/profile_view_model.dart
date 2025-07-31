// feature/auth/presentation/view_model/profile_view_model/profile_view_model.dart

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/usecase/get_user_usecase.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/usecase/update_user_usecase.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/usecase/user_logout_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final GetUserUsecase _userGetUseCase;
  final UserUpdateUsecase _userUpdateUsecase;
  final UserLogoutUseCase _userLogoutUseCase;

  ProfileViewModel({
    required GetUserUsecase userGetUseCase,
    required UserUpdateUsecase userUpdateUseCase,
    required UserLogoutUseCase userLogoutUseCase,
  }) : _userUpdateUsecase = userUpdateUseCase,
       _userGetUseCase = userGetUseCase,
       _userLogoutUseCase = userLogoutUseCase,
       super(ProfileState.initial()) {
    on<LoadProfileEvent>(_onProfileLoad);
    on<UpdateProfileEvent>(_onProfileUpdate);
    on<ToggleEditModeEvent>(_onToggleEditMode);
    on<ClearMessageEvent>(_onClearMessage);
    on<ProfileImagePickedEvent>(_onProfileImagePicked);
    on<LogoutEvent>(_onLogout);

    add(LoadProfileEvent());
  }

  // --- No changes to other methods ---

  void _onProfileImagePicked(
    ProfileImagePickedEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(newProfileImageFile: () => event.imageFile));
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
      (updatedUser) => emit(
        state.copyWith(
          isLoading: false,
          authEntity: updatedUser,
          isEditing: false,
          errorMessage: () => 'Profile updated successfully!',
          newProfileImageFile: () => null,
        ),
      ),
    );
  }

  void _onClearMessage(ClearMessageEvent event, Emitter<ProfileState> emit) {
    emit(state.copyWith(errorMessage: () => null));
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _userLogoutUseCase();
    result.fold(
      (failure) {
        emit(
          state.copyWith(isLoading: false, errorMessage: () => failure.message),
        );
      },
      (success) {
        emit(state.copyWith(isLoading: false, isLoggedOut: true));
      },
    );
  }
}
