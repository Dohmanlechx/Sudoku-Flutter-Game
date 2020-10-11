import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/providers/board_provider.dart';
import 'package:sudoku_game/styles/colors.dart';
import 'package:sudoku_game/widgets/common/non_scrollable_grid_view.dart';
import 'package:sudoku_game/widgets/game_screen/tile.dart';

class TileGroup extends StatefulWidget {
  final int groupIndex;

  const TileGroup({this.groupIndex});

  @override
  _TileGroupState createState() => _TileGroupState();
}

class _TileGroupState extends State<TileGroup> {
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
    final _provider = context.watch<BoardProvider>();
    final _numbers = _provider.boardByGroup[widget.groupIndex];

    return NonScrollableGridView(
      children: List<Widget>.generate(9, (int i) {
        final isOccupied = _provider.isOccupiedNumber(
          index: i,
          number: _numbers[i],
          groupIndex: widget.groupIndex,
        );
        return Center(
          child: Tile(
            number: _numbers[i],
            isInvalid: isOccupied,
            onSubmit: (int num) {
              assert(num <= 9);
              setState(() {
                _provider.setNumber(
                  groupIndex: widget.groupIndex,
                  index: i,
                  number: num == 0 ? null : num,
                );
              });
            },
          ),
        );
      }),
    );
  }
}
