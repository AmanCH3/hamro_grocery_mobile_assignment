import 'package:flutter/material.dart';
import 'package:hamro_grocery_mobile/common/color_extension.dart';


class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: "Gilroy",
      colorScheme: ColorScheme.fromSeed(seedColor: TColor.primary),
      useMaterial3: false,
    );
  }
}
