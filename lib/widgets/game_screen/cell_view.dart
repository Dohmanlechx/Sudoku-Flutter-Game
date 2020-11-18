import 'package:flutter/material.dart';
import 'package:sudoku_game/models/cell.dart';
import 'package:sudoku_game/styles/colors.dart';
import 'package:sudoku_game/styles/typography.dart';
import 'package:sudoku_game/widgets/common/non_scrollable_grid_view.dart';

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
          color: cell.isHighlighted ? AppColors.highlight.withOpacity(0.7) : AppColors.white,
          border: Border.all(width: 0.5),
        ),
        child: _buildNumber(),
      ),
    );
  }

  Widget _buildNumber() {
    final _cellNumber = (cell.number ?? '').toString();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: cell.isSelected ? AppColors.red : Colors.transparent, width: 2),
      ),
      child: _cellNumber.isNotEmpty
          ? _buildTextInNumber(_cellNumber)
          : cell.maybeNumbers.isNotEmpty
              ? NonScrollableGridView(
                  children: List<Widget>.generate(9, (int index) {
                    return cell.maybeNumbers.contains(index + 1)
                        ? Text(
                            (index + 1).toString(),
                            textAlign: TextAlign.center,
                            style: AppTypography.body.copyWith(fontSize: 10),
                          )
                        : const SizedBox();
                  }),
                )
              : _buildTextInNumber(''),
    );
  }

  Widget _buildTextInNumber(String copy) {
    return Center(
      child: Text(copy, style: AppTypography.timer.copyWith(color: _getDigitColor())),
    );
  }

  Color _getDigitColor() {
    if (cell.number == 0) {
      return Colors.transparent;
    } else if (isInvalid) {
      return AppColors.red;
    } else if (cell.isClickable) {
      return AppColors.accent;
    } else {
      return AppColors.black;
    }
  }
}
