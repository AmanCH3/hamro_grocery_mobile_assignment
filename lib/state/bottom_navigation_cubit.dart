import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/favorite/view/favorite_screen.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view/order_detail_screen.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view/order_screen.dart';
import 'package:hamro_grocery_mobile/view/auth/dashboard/history_screen.dart';
import 'package:hamro_grocery_mobile/view/auth/dashboard/home_screen.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view/profile_screen.dart';
import 'bottom_navigation_state.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const OrderScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  final List<String> _appBarTitles = [
    'Hamro Grocery',
    'My List',
    'My Favourite',
    'Profile',
  ];

  BottomNavigationCubit()
    : super(
        BottomNavigationState(
          currentIndex: 0,
          appBarTitle: 'Hamro Grocery',
          currentScreen: const HomeScreen(),
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
}
