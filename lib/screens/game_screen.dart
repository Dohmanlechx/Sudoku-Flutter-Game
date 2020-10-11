import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/app/strings.dart';
import 'package:sudoku_game/providers/board_provider.dart';
import 'package:sudoku_game/styles/colors.dart';
import 'package:sudoku_game/util/device_info.dart';
import 'package:sudoku_game/widgets/common/app_drawer.dart';
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
      appBar: AppBar(
        title: const Text(AppTranslations.appTitle),
        elevation: 50,
      ),
      drawer: AppDrawer(),
      backgroundColor: AppColors.primary,
      body: _buildSudokuGrid(),
    );
  }

  Widget _buildSudokuGrid() {
    return context.watch<BoardProvider>().isBoardDoneBuilt()
        ? Container(
            margin: const EdgeInsets.only(top: 32),
            padding: const EdgeInsets.all(8),
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
          )
        : _buildCircleLoader();
  }

  Widget _buildCircleLoader() {
    const double _progressSize = 70;
    return Center(
      child: Stack(
        children: [
          Container(
            width: _progressSize,
            height: _progressSize,
            child: const CircularProgressIndicator(
              strokeWidth: 5,
              backgroundColor: Colors.grey,
            ),
          ),
          Container(
            width: _progressSize,
            height: _progressSize,
            child: const Center(child: Text(AppTranslations.loading)),
          ),
        ],
      ),
    );
  }
}
