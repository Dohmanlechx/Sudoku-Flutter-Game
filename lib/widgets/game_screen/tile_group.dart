import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/app/colors.dart';
import 'package:sudoku_game/providers/board_provider.dart';
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
    final _provider = Provider.of<BoardProvider>(context, listen: true);
    final _numbers = _provider.boardByGroup[widget.groupIndex];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(),
      ),
      child: NonScrollableGridView(
        children: List<Widget>.generate(9, (int i) {
          return Center(
            child: Tile(
              number: _numbers[i],
              isInvalid: _provider.isOccupiedNumber(
                index: i,
                number: _numbers[i],
                groupIndex: widget.groupIndex,
              ),
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
      ),
    );
  }
}
