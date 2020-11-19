import 'package:flutter/material.dart';
import 'package:sudoku_game/util/extensions.dart';

final appTheme = ThemeData(
  fontFamily: 'Coolvetica',
  primaryColor: AppColors.primary,
  backgroundColor: AppColors.primary,
  accentColor: AppColors.accent,
  dividerColor: AppColors.grey,
  appBarTheme: const AppBarTheme(
    textTheme: TextTheme(),
    color: AppColors.accent,
  ),
);

final appThemeDark = ThemeData(
  fontFamily: 'Coolvetica',
  primaryColor: AppColors.primaryDark,
  backgroundColor: AppColors.primary,
  accentColor: AppColors.accent,
  dividerColor: AppColors.grey,
  appBarTheme: const AppBarTheme(
    textTheme: TextTheme(),
    color: AppColors.accent,
  ),
);

abstract class CustomColors {
  // Custom colors that don't fit in the ThemeData
  static Color appBarText(BuildContext context) => context.isLightMode() ? AppColors.white : AppColors.black;
}

abstract class AppColors {
  static const primary = Color(0xFFD6E4EE);
  static const primaryDark = Colors.grey;
  static const accent = Color(0xFF668BA6);
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const grey = Color(0xFFC2C2C2);
  static const red = Color(0xFFED0000);
  static const lightGrey = Color(0xFFF0F0F0);
  static const green = Color(0xFF5AD3A9);
  static const highlight = Color(0xFFD6DBDF);
}
