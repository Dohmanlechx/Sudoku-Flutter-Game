import 'package:flutter/material.dart';
import 'package:sudoku_game/app/colors.dart';
import 'package:sudoku_game/widgets/common/non_scrollable_grid_view.dart';
import 'package:sudoku_game/widgets/game_screen/tile.dart';

class TileGroup extends StatelessWidget {
  const TileGroup();

  @override
  Widget build(BuildContext context) {
    const _tileRows = <List<int>>[
      [0, 1, 2],
      [0, 1, 2],
      [0, 1, 2],
    ];

    List<int> _numbers;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(),
      ),
      child: NonScrollableGridView(
        children: List.generate(9, (i) {
          return const Center(
            child: Tile(),
          );
        }),
      ),
    );
  }
}
