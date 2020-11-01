import 'package:flutter/cupertino.dart';
import 'package:sudoku_game/styles/colors.dart';

abstract class AppTypography {
  static const body = TextStyle(
    fontSize: 22,
  );

  static const dividerTitle = TextStyle(
    fontSize: 20,
    color: AppColors.grey,
  );

  static const roundDone = TextStyle(
    fontSize: 40,
    color: AppColors.white,
  );

  static const timer = TextStyle(
    fontFamily: 'Consolas', // Monospaced, fixed width for every char
    fontWeight: FontWeight.bold,
    fontSize: 22,
  );
}
