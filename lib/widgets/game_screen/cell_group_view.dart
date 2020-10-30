import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/models/cell.dart';
import 'package:sudoku_game/providers/board_provider.dart';
import 'package:sudoku_game/styles/colors.dart';
import 'package:sudoku_game/widgets/common/non_scrollable_grid_view.dart';
import 'package:sudoku_game/widgets/game_screen/cell_view.dart';

class CellGroupView extends StatelessWidget {
  const CellGroupView({this.groupIndex});

  final int groupIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(),
      ),
      child: _buildTileGroupGrid(context),
    );
  }

  Widget _buildTileGroupGrid(BuildContext context) {
    final BoardProvider _provider = context.watch<BoardProvider>();
    final List<Cell> _cells = _provider.boardByGroup[groupIndex];

    return NonScrollableGridView(
      children: List<Widget>.generate(9, (int index) {
        final _isOccupied = _provider.isOccupiedNumberInGroup(
          index: index,
          number: _cells[index].number,
          groupIndex: groupIndex,
        );

        return Center(
          child: CellView(
            cell: _cells[index],
            isInvalid: _isOccupied || (_cells[index].number != _cells[index].solutionNumber),
            onSubmit: () => _provider.setSelectedCoordinates(groupIndex, index),
          ),
        );
      }),
    );
  }
}
