import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/app/service_locator/service_locator.dart';
import 'package:hamro_grocery_mobile/common/app_flush.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/usecase/register_usecase.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view/signin_page.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/register_view_model/register_state.dart';


class RegisterViewModel extends Bloc<RegisterEvent, RegisterState> {
  final UserRegisterUseCase _userRegisterUseCase;

  RegisterViewModel(this._userRegisterUseCase)
    : super(RegisterState.initial()) {
    on<RegisterUserEvent>(_onRegisterUser);
    on<NavigateToLoginEvent>(_onNavigateToLoginEvent);
  }

  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 1));

    // Print submitted data
    print(' Submitted Data:');
    print('fullName: ${event.fullName}');
    print('Email: ${event.email}');
    print('Password: ${event.password}');
    

    final result = await _userRegisterUseCase(
      RegisterUserParams(
        email: event.email,
        fullName: event.fullName,
        password: event.password,
       
      ),
    );

    result.fold(
      (l) async {
        emit(state.copyWith(isLoading: false));

        if (event.context.mounted) {
          await AppFlushbar.show(
            context: event.context,
            message: "Something went wrong",

            icon: const Icon(Icons.check_circle, color: Colors.white),
            backgroundColor: Colors.green,
          );
        }
      },
      (r) async {
        emit(state.copyWith(isLoading: false, isSuccess: true));

        if (event.context.mounted) {
          Navigator.push(
            event.context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider.value(
                    value: serviceLocator<LoginViewModel>(),
                    child: SignInPage(),
                  ),
            ),
          );
          await AppFlushbar.show(
            context: event.context,
            message: "Signup successful!",
            icon: const Icon(Icons.check_circle, color: Colors.white),
            backgroundColor: Colors.green,
          );
        }
      },
    );
  }

  void _onNavigateToLoginEvent(
    NavigateToLoginEvent event,
    Emitter<RegisterState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<LoginViewModel>(),
                child: SignInPage(),
              ),
        ),
      );
    }
  }
}