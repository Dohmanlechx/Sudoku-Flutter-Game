import 'package:flutter/material.dart';
import 'package:sudoku_game/app/colors.dart';
import 'package:sudoku_game/widgets/common/non_scrollable_grid_view.dart';
import 'package:sudoku_game/widgets/game_screen/tile.dart';
import 'package:sudoku_game/util/extensions.dart';

class TileGroup extends StatefulWidget {
  const TileGroup();

  @override
  _TileGroupState createState() => _TileGroupState();
}

class _TileGroupState extends State<TileGroup> {
  final List<int> _numbers = List(9);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(),
      ),
      child: NonScrollableGridView(
        children: List.generate(9, (i) {
          return Center(
            child: Tile(
              number: _numbers[i],
              isInvalid: _numbers.where((e) => e.isEqualTo(_numbers[i])).length > 1,
              onSubmit: (int num) {
                assert(num <= 9);
                setState(() {
                  _numbers[i] = num == 0 ? null : num;
                });
              },
            ),
          );
        }),
      ),
    );
  }
}
