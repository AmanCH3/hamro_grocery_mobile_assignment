import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class BottomNavigationState extends Equatable {
  final int currentIndex;
  final String appBarTitle;
  // ADD THIS LINE
  final Widget currentScreen;

  const BottomNavigationState({
    required this.currentIndex,
    required this.appBarTitle,
    // ADD THIS LINE
    required this.currentScreen,
  });

  @override
  // ADD currentScreen TO PROPS
  List<Object?> get props => [currentIndex, appBarTitle, currentScreen];
}
