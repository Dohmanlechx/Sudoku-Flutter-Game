import 'package:flutter/material.dart';
import 'package:sudoku_game/app/colors.dart';

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
      child: GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        children: [
          ...List.generate(9, (i) {
            return Center(
              child: Text(i.toString()),
            );
          })
        ],
      ),
    );
  }
}
