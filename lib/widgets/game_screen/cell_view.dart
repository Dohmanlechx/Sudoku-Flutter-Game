import 'package:flutter/material.dart';
import 'package:sudoku_game/models/cell.dart';
import 'package:sudoku_game/styles/colors.dart';
import 'package:sudoku_game/styles/typography.dart';

class CellView extends StatelessWidget {
  const CellView({
    this.cell,
    this.isInvalid,
    this.onSubmit,
  });

  final Cell cell;
  final bool isInvalid;
  final Function onSubmit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSubmit,
      child: Container(
        decoration: BoxDecoration(
          color: cell.number == null || (cell.isClickable && !isInvalid)
              ? AppColors.white
              : isInvalid
                  ? AppColors.red.withOpacity(0.1)
                  : null,
          border: Border.all(width: 0.5),
        ),
        child: _buildNumber(),
      ),
    );
  }

  Widget _buildNumber() {
    return Container(
      decoration: cell.isSelected
          ? BoxDecoration(
              border: Border.all(color: AppColors.red, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            )
          : null,
      child: Center(
        child: Text(
          (cell.number ?? '').toString(),
          style: AppTypography.body,
        ),
      ),
    );
  }
}
