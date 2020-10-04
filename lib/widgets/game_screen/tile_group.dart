import 'package:flutter/material.dart';
import 'package:sudoku_game/app/colors.dart';
import 'package:sudoku_game/widgets/common/non_scrollable_grid_view.dart';

class TileGroup extends StatefulWidget {
  const TileGroup();

  @override
  _TileGroupState createState() => _TileGroupState();
}

class _TileGroupState extends State<TileGroup> {
  final List<List<int>> _tileRows = [
    [0, 1, 2],
    [0, 1, 2],
    [0, 1, 2],
  ];

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
            child: Text(i.toString()),
          );
        }),
      ),
    );
  }
}
