import 'package:flutter/material.dart';
import 'package:sudoku_game/app/colors.dart';
import 'package:sudoku_game/app/typography.dart';

class Tile extends StatelessWidget {
  const Tile();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
      ),
      child: TextField(
        buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
        keyboardType: TextInputType.number,
        maxLength: 1,
        showCursor: false,
        textAlign: TextAlign.center,
        style: AppTypography.number,
        enableInteractiveSelection: false,
        decoration: const InputDecoration(
          fillColor: Colors.transparent,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.red, width: 3),
          ),
        ),
      ),
    );
  }
}
