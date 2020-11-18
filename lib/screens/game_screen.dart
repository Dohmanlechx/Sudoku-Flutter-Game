import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/app/strings.dart';
import 'package:sudoku_game/providers/game_provider.dart';
import 'package:sudoku_game/styles/colors.dart';
import 'package:sudoku_game/styles/typography.dart';
import 'package:sudoku_game/util/device_util.dart';
import 'package:sudoku_game/util/extensions.dart';
import 'package:sudoku_game/widgets/common/app_drawer.dart';
import 'package:sudoku_game/widgets/common/non_scrollable_grid_view.dart';
import 'package:sudoku_game/widgets/game_screen/cell_group_view.dart';
import 'package:sudoku_game/widgets/game_screen/stop_watch_view.dart';

class GameScreen extends StatelessWidget {
  const GameScreen();

  @override
  Widget build(BuildContext context) {
    final _provider = context.watch<GameProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text(AppTranslations.appTitle)),
      drawer: const AppDrawer(),
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Stack(
              children: [
                _buildSudokuGrid(context),
                Stack(
                  children: [
                    _provider.isWonRound
                        ? _buildCongratsOverlay(context)
                        : _provider.isGameOver
                            ? _buildGameOverOverlay(context)
                            : const SizedBox(),
                    if (_provider.isWonRound || _provider.isGameOver) _buildStartNewGameTutorialText(context),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(flex: 1, child: _buildDifficultyText(context)),
                  Expanded(flex: 1, child: _buildLives(context)),
                  const Expanded(flex: 1, child: StopWatchView()),
                ],
              ),
            ),
            _buildNumbersKeyboard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSudokuGrid(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      width: DeviceUtil.width(context),
      height: DeviceUtil.width(context),
      child: Center(
        child: Container(
          decoration: BoxDecoration(border: Border.all()),
          child: NonScrollableGridView(
            children: List<Widget>.generate(9, (int i) {
              return CellGroupView(groupIndex: i);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildCongratsOverlay(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: DeviceUtil.width(context),
      height: DeviceUtil.width(context),
      color: AppColors.green.withOpacity(0.95),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.star, size: 48, color: AppColors.white),
          Text(AppTranslations.congrats, style: AppTypography.roundDone),
          Icon(Icons.star, size: 48, color: AppColors.white),
        ],
      ),
    );
  }

  Widget _buildStartNewGameTutorialText(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.arrow_upward, color: AppColors.white, size: 32),
          Text(AppTranslations.newGameTutorial, style: AppTypography.roundDone.copyWith(fontSize: 16))
        ],
      ),
    );
  }

  Widget _buildGameOverOverlay(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: DeviceUtil.width(context),
      height: DeviceUtil.width(context),
      color: AppColors.grey.withOpacity(0.95),
      child: const Center(child: Text(AppTranslations.gameOver, style: AppTypography.roundDone)),
    );
  }

  Widget _buildDifficultyText(BuildContext context) {
    return Center(
      child: Text(
        context.watch<GameProvider>().selectedDifficulty.toString().split('.').last.capitalize(),
        style: AppTypography.body,
      ),
    );
  }

  Widget _buildLives(BuildContext context) {
    final int _lives = context.watch<GameProvider>().lives;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
            3,
            (int index) => Icon(index < _lives ? Icons.favorite : Icons.favorite_outline),
          )
        ],
      ),
    );
  }

  Widget _buildNumbersKeyboard(BuildContext context) {
    final _watchProvider = context.watch<GameProvider>();
    final _buttonContentSize = DeviceUtil.isSmallDevice(context) ? 20.0 : 40.0;
    final _buttonMarginSize = DeviceUtil.isSmallDevice(context) ? 2.0 : 4.0;

    return Container(
      color: AppColors.lightGrey,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(8),
      child: NonScrollableGridView(
          childAspectRatio: DeviceUtil.isSmallDevice(context) ? 3 / 2 : null,
          crossAxisCount: 5,
          children: List<Widget>.generate(
            10,
            (int index) {
              final _number = ++index;
              final _canGameContinue = !_watchProvider.isWonRound &&
                  !_watchProvider.isGameOver &&
                  _watchProvider.selectedCell.coordinates.isNotEmpty;

              return Container(
                margin: EdgeInsets.all(_buttonMarginSize),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  border: Border.all(color: AppColors.black, width: 3),
                ),
                child: Material(
                  child: InkWell(
                    onLongPress: _canGameContinue ? () => _setMaybeNumber(context, _number) : null,
                    onTap: _canGameContinue ? () => _setNumber(context, _number) : null,
                    child: Center(
                      child: _number < 10
                          ? Text(_number.toString(), style: AppTypography.body.copyWith(fontSize: _buttonContentSize))
                          : Icon(Icons.delete, size: _buttonContentSize),
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  void _setMaybeNumber(BuildContext context, int number) {
    context.read<GameProvider>().setMaybeNumber(
      maybeNumberInput: number < 10 ? number : null,
      isDelete: number == 10,
    );
  }

  void _setNumber(BuildContext context, int number) {
    context.read<GameProvider>().setNumber(
          numberInput: number < 10 ? number : null,
          isDelete: number == 10,
        );
  }
}
