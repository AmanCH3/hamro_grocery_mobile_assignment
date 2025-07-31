import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/app/service_locator/service_locator.dart';
import 'package:hamro_grocery_mobile/app/theme/theme.dart';

import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:hamro_grocery_mobile/feature/category/presentation/view_model/category_view_model.dart';
import 'package:hamro_grocery_mobile/splash/splash_screen.dart';
import 'package:hamro_grocery_mobile/state/bottom_navigation_cubit.dart';

import 'feature/auth/presentation/view_model/profile_view_model/profile_view_model.dart';
import 'feature/order/presentation/view_model/cart_event.dart';
import 'feature/order/presentation/view_model/cart_view_model.dart';
import 'feature/order/presentation/view_model/order_view_model.dart';
import 'feature/product/presentation/view_model/product_view_model.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
        BlocProvider(
        create: (context) => serviceLocator<ProductViewModel>(),
    ),
    BlocProvider(create: (context) => serviceLocator<CategoryViewModel>() ,),
    BlocProvider(
      create: (context) => serviceLocator<CartBloc>()..add(LoadCart()),
    ),
    BlocProvider(
    create: (context) => serviceLocator<OrderBloc>(),
    ),
    BlocProvider(
    create: (context) => serviceLocator<ProfileViewModel>(),
    ),
    BlocProvider(
    create: (context) => BottomNavigationCubit(),
    ),
    ],
    child : MaterialApp(
      title: 'hamro grocery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, 
      home: BlocProvider.value(
        value: serviceLocator<LoginViewModel>(),
        child: SplashScreen(),
      ),
    ) ,
    ) ;
  }
}
