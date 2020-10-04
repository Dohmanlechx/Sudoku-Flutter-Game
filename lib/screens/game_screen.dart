import 'package:flutter/material.dart';
import 'package:sudoku_game/app/colors.dart';
import 'package:sudoku_game/util/device_info.dart';

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: DeviceInfo.width(context),
              height: DeviceInfo.width(context),
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
