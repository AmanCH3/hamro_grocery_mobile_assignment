import 'package:flutter/material.dart';

class BottomNavigationState {
  final int currentIndex;
  final Widget currentScreen;
  final String appBarTitle;

  const BottomNavigationState({
    required this.currentIndex,
    required this.currentScreen,
    required this.appBarTitle,
  });
}
