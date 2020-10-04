import 'package:flutter/material.dart';
import 'package:sudoku_game/app/colors.dart';
import 'package:sudoku_game/util/device_info.dart';
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            width: DeviceInfo.width(context),
            height: DeviceInfo.width(context),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: GridView.count(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  children: [
                    ...List.generate(9, (i) {
                      return const TileGroup();
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
