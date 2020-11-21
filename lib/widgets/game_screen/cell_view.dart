import 'package:flutter/material.dart';
import 'package:sudoku_game/models/cell.dart';
import 'package:sudoku_game/styles/theme.dart';
import 'package:sudoku_game/styles/typography.dart';
import 'package:sudoku_game/util/device_util.dart';
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
          color: cell.isHighlighted ? AppColors.boardHighlight.withOpacity(0.75) : AppColors.board,
          border: Border.all(width: 0.5, color: AppColors.boardAccent),
        ),
        child: _buildNumber(context),
      ),
    );
  }

  Widget _buildNumber(BuildContext context) {
    final _cellNumber = (cell.number ?? '').toString();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: cell.isSelected ? AppColors.red : Colors.transparent, width: 2),
      ),
      child: _cellNumber.isNotEmpty
          ? _buildTextInNumber(context, _cellNumber)
          : cell.maybeNumbers.isNotEmpty
              ? NonScrollableGridView(
                  children: List<Widget>.generate(9, (int index) {
                    return cell.maybeNumbers.contains(index + 1)
                        ? Text(
                            (index + 1).toString(),
                            textAlign: TextAlign.center,
                            style: AppTypography.body.copyWith(
                              color: AppColors.boardAccent,
                              fontSize: DeviceUtil.isSmallDevice(context, limit: 1280) ? 8 : 11,
                            ),
                          )
                        : const SizedBox();
                  }),
                )
              : _buildTextInNumber(context, ''),
    );
  }

  Widget _buildTextInNumber(BuildContext context, String copy) {
    return Container(
      decoration: isInvalid && cell.number != null
          ? BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              color: AppColors.red.withOpacity(cell.isClickable ? 0.75 : 0.5),
            )
          : null,
      child: Center(
        child: Text(copy, style: AppTypography.timer.copyWith(color: _getDigitColor(context))),
      ),
    );
  }

  Color _getDigitColor(BuildContext context) {
    if (cell.number == 0) {
      return Colors.transparent;
    } else if (cell.isClickable && cell.number == cell.solutionNumber) {
      return Theme.of(context).accentColor;
    } else {
      return AppColors.boardAccent;
    }
  }
}
