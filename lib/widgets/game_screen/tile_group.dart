import 'package:flutter/material.dart';
import 'package:sudoku_game/app/colors.dart';
import 'package:sudoku_game/util/extensions.dart';
import 'package:sudoku_game/widgets/common/non_scrollable_grid_view.dart';
import 'package:sudoku_game/widgets/game_screen/tile.dart';

class TileGroup extends StatefulWidget {
  final List<int> numbers;

  const TileGroup({this.numbers});

  @override
  _TileGroupState createState() => _TileGroupState();
}

class _TileGroupState extends State<TileGroup> {
  List<int> _numbers;

  @override
  void initState() {
    _numbers = widget.numbers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
