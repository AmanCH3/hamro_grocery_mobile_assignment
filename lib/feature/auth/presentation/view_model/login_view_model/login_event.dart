import 'package:flutter/material.dart';

@immutable
sealed class LoginEvent {}

class NavigateToRegisterView extends LoginEvent {
  final BuildContext context;

  NavigateToRegisterView({required this.context});
}

class NavigateToHomeView extends LoginEvent {
  final BuildContext context;

  NavigateToHomeView({required this.context});
}

class LoginWithEmailAndPassword extends LoginEvent {
  final BuildContext context;
  final String email;
  final String password;

  LoginWithEmailAndPassword({
    required this.context,
    required this.email,
    required this.password,
  });
}