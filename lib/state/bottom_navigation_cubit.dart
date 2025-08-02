import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view/profile_screen.dart';
import 'package:hamro_grocery_mobile/feature/favorite/view/favorite_screen.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view/order_screen.dart';
import 'package:hamro_grocery_mobile/view/auth/dashboard/home_screen.dart';

import 'bottom_navigation_state.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  // The list of screens is now managed here
  final List<Widget> _screens = [
    // Note: We'll pass a dummy function for now, as the AppBar is handled centrally.
    const HomeScreen(openDrawer: _dummyOpenDrawer),
    const OrderScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  final List<String> _appBarTitles = [
    'Hamro Grocery',
    'My Cart',
    'My Favourite',
    'Profile',
  ];

  BottomNavigationCubit()
    : super(
        BottomNavigationState(
          currentIndex: 0,
          appBarTitle: 'Hamro Grocery',
          // Set the initial screen
          currentScreen: const HomeScreen(openDrawer: _dummyOpenDrawer),
        ),
      );

  void updateIndex(int index) {
    if (index >= 0 && index < _screens.length) {
      emit(
        BottomNavigationState(
          currentIndex: index,
          currentScreen: _screens[index],
          appBarTitle: _appBarTitles[index],
        ),
      );
    }
  }

  // A static dummy function to satisfy HomeScreen's requirement without needing a key
  static void _dummyOpenDrawer() {}
}
