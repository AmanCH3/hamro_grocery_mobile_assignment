import 'package:flutter/cupertino.dart';

@immutable
sealed class RegisterEvent {}

class NavigateToLoginEvent extends RegisterEvent {
  final BuildContext context;

  NavigateToLoginEvent({required this.context});
}

class RegisterUserEvent extends RegisterEvent {
  final BuildContext context;

  final String fullName;
  final String password;
  final String email;


  RegisterUserEvent({
    required this.context,
    required this.fullName,
    required this.password,
    required this.email,
  });
}