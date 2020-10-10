import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/app/colors.dart';
import 'package:sudoku_game/providers/board_provider.dart';
import 'package:sudoku_game/util/device_info.dart';
import 'package:sudoku_game/widgets/common/non_scrollable_grid_view.dart';
import 'package:sudoku_game/widgets/game_screen/tile_group.dart';

class GameScreen extends StatefulWidget {
  const GameScreen();

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: InteractiveViewer(
        minScale: 1.0,
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                width: DeviceInfo.width(context),
                height: DeviceInfo.width(context),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: NonScrollableGridView(
                      children: List<Widget>.generate(9, (int i) {
                        return TileGroup(groupIndex: i);
                      }),
                    ),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  context.read<BoardProvider>().initBoard();
                  context.read<BoardProvider>().initBoard();
                },
                child: Text("Init"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
