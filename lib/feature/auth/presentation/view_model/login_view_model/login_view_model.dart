import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/app/service_locator/service_locator.dart';
import 'package:hamro_grocery_mobile/common/app_flush.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/usecase/login_usecase.dart';

import 'package:hamro_grocery_mobile/feature/auth/presentation/view/signup_page.dart';
import 'package:hamro_grocery_mobile/state/dashboard_screen.dart';
import 'package:hamro_grocery_mobile/view/auth/dashboard/grocery_app_home.dart';

import '../register_view_model/register_view_model.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUseCase _userLoginUseCase;

  LoginViewModel(this._userLoginUseCase) : super(LoginState.initial()) {
    on<NavigateToRegisterView>(_onNavigateToRegisterView);
    on<NavigateToHomeView>(_onNavigateToHomeView);
    on<LoginWithEmailAndPassword>(_onLoginWithEmailAndPassword);
  }

  void _onNavigateToRegisterView(
    NavigateToRegisterView event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: serviceLocator<RegisterViewModel>(),
                child: const SignUpPage(),
              ),
        ),
      );
    }
  }

  void _onNavigateToHomeView(
    NavigateToHomeView event,
    Emitter<LoginState> emit,
  ) async {
    Navigator.pushAndRemoveUntil(
      event.context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
      (route) => false,
    );
    await AppFlushbar.show(
      context: event.context,
      message: "Login successful!",
      backgroundColor: Colors.green,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  void _onLoginWithEmailAndPassword(
    LoginWithEmailAndPassword event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _userLoginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
      },
      (email) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        add(NavigateToHomeView(context: event.context));
      },
    );
  }
}
