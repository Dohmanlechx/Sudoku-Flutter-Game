import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/app/strings.dart';
import 'package:sudoku_game/providers/board_provider.dart';
import 'package:sudoku_game/styles/colors.dart';
import 'package:sudoku_game/styles/typography.dart';
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
      body: context.watch<BoardProvider>().isBoardDoneBuilt()
          ? SingleChildScrollView(
              child: Column(
                children: [
                  _buildSudokuGrid(),
                  const SizedBox(height: 32),
                  _buildNumbersKeyboard(),
                ],
              ),
            )
          : _buildCircleLoader(),
    );
  }

  Widget _buildSudokuGrid() {
    return Container(
      child: Container(
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
      ),
    );
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

  Widget _buildNumbersKeyboard() {
    return Container(
      color: AppColors.lightGrey,
      padding: const EdgeInsets.all(8),
      child: NonScrollableGridView(
        crossAxisCount: 5,
        children: List<Widget>.generate(10, (int index) {
          final number = ++index;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              border: Border.all(color: AppColors.black, width: 3),
            ),
            child: Material(
              child: InkWell(
                onTap: () => context.read<BoardProvider>().setNumber(number < 10 ? number : null),
                child: Center(
                  child: number < 10
                      ? Text(
                          number.toString(),
                          style: AppTypography.number.copyWith(fontSize: 40),
                        )
                      : const Icon(Icons.delete, size: 40),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
