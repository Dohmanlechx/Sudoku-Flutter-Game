import 'package:flutter/material.dart';
import 'package:sudoku_game/styles/colors.dart';

final appTheme = ThemeData(
  fontFamily: 'Coolvetica',
  backgroundColor: AppColors.primary,
  accentColor: AppColors.accent,
  dividerColor: AppColors.grey,
  appBarTheme: const AppBarTheme(
    color: AppColors.accent,
  ),
);