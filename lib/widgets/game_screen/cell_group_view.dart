import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/models/cell.dart';
import 'package:sudoku_game/providers/board_provider.dart';
import 'package:sudoku_game/styles/colors.dart';
import 'package:sudoku_game/widgets/common/non_scrollable_grid_view.dart';
import 'package:sudoku_game/widgets/game_screen/cell_view.dart';

class CellGroupView extends StatefulWidget {
  final int groupIndex;

  const CellGroupView({this.groupIndex});

  @override
  _CellGroupViewState createState() => _CellGroupViewState();
}

class _CellGroupViewState extends State<CellGroupView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        border: Border.all(),
      ),
      child: _buildTileGroupGrid(context),
    );
  }

  Widget _buildTileGroupGrid(BuildContext context) {
    final BoardProvider _provider = context.watch<BoardProvider>();
    final List<Cell> _cells = _provider.boardByGroup[widget.groupIndex];

    return NonScrollableGridView(
      children: List<Widget>.generate(9, (int index) {
        final _isOccupied = _provider.isOccupiedNumberInGroup(
          index: index,
          number: _cells[index].number,
          groupIndex: widget.groupIndex,
        );
        final _coordinates = _provider.getCoordinates(widget.groupIndex)[index];

        return Center(
          child: CellView(
            number: _cells[index].number,
            isInvalid: _isOccupied,
            coordinates: _coordinates,
            isSelected: listEquals(_provider.selectedCoordinates, _coordinates),
            onSubmit: () => _provider.setSelectedCoordinates(widget.groupIndex, index),
          ),
        );
      }),
    );
  }
}
