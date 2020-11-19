import 'package:flutter/material.dart';
import 'package:sudoku_game/internal_storage.dart';

final appTheme = ThemeData(
  fontFamily: 'Coolvetica',
  primaryColor: AppColors.primary,
  backgroundColor: AppColors.primary,
  accentColor: AppColors.accent,
  appBarTheme: const AppBarTheme(
    textTheme: TextTheme(),
    color: AppColors.accent,
  ),
);

final appThemeDark = ThemeData(
  fontFamily: 'Coolvetica',
  primaryColor: AppColors.primaryDark,
  backgroundColor: AppColors.primaryDark,
  accentColor: AppColors.accentDark,
  appBarTheme: const AppBarTheme(
    textTheme: TextTheme(),
    color: AppColors.grey,
  ),
);

abstract class AppColors {
  // Custom colors that don't fit in the ThemeData
  static Color get appBarText => InternalStorage.isNightModeEnabled ? AppColors.black : AppColors.white;

  static Color get board => InternalStorage.isNightModeEnabled ? AppColors.darkGrey : AppColors.white;

  static Color get boardAccent => InternalStorage.isNightModeEnabled ? AppColors.grey : AppColors.black;

  static Color get boardHighlight => InternalStorage.isNightModeEnabled ? AppColors.black : AppColors.highlight;

  static Color get keyboard => InternalStorage.isNightModeEnabled ? AppColors.darkGrey : AppColors.lightGrey;

  static Color get keyboardButton => InternalStorage.isNightModeEnabled ? AppColors.lightGrey : AppColors.white;

  static Color get drawer => InternalStorage.isNightModeEnabled ? AppColors.primaryDark : AppColors.lightGrey;

  static Color get drawerTitle => InternalStorage.isNightModeEnabled ? AppColors.darkGrey : AppColors.grey;

  static const primary = Color(0xFFD6E4EE);
  static const primaryDark = Color(0xFFC2C2C2);
  static const accent = Color(0xFF668BA6);
  static const accentDark = Color(0xFFF0F0F0);
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const grey = Color(0xFFC2C2C2);
  static const red = Color(0xFFBA3939);
  static const lightGrey = Color(0xFFF0F0F0);
  static const darkGrey = Color(0xFF5A5B56);
  static const green = Color(0xFF5AD3A9);
  static const highlight = Color(0xFFD6DBDF);
  static const highlightDark = Color(0xFFC9C7C7);
}
