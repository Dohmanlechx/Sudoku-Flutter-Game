import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/app/strings.dart';
import 'package:sudoku_game/providers/game_provider.dart';
import 'package:sudoku_game/providers/settings_provider.dart';
import 'package:sudoku_game/styles/theme.dart';
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

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.appBarText),
          title: Text(
            AppTranslations.appTitle,
            style: AppTypography.body.copyWith(color: AppColors.appBarText),
          ),
        ),
        drawer: const AppDrawer(),
        backgroundColor: Theme.of(context).primaryColor,
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
                      if (_provider.isWonRound || _provider.isGameOver)
                        _buildStartNewGameTutorialText(context),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: context.watch<SettingsProvider>().isSundayModeEnabled
                    ? Row(
                        children: [
                          Expanded(
                              flex: 1, child: _buildDifficultyText(context)),
                          Expanded(flex: 1, child: _buildSundayText()),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                              flex: 1, child: _buildDifficultyText(context)),
                          Expanded(flex: 1, child: _buildLives(context)),
                          const Expanded(flex: 1, child: StopWatchView()),
                        ],
                      ),
              ),
              _buildNumbersKeyboard(context),
            ],
          ),
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
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          Text(AppTranslations.newGameTutorial,
              style: AppTypography.roundDone.copyWith(fontSize: 16))
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
      child: const Center(
          child:
              Text(AppTranslations.gameOver, style: AppTypography.roundDone)),
    );
  }

  Widget _buildDifficultyText(BuildContext context) {
    final _selectedDifficulty =
        context.watch<GameProvider>().selectedDifficulty;

    return Center(
      child: Text(
        (_selectedDifficulty.asString() ?? '').capitalize(),
        style: AppTypography.body.copyWith(color: AppColors.black),
      ),
    );
  }

  Widget _buildSundayText() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.all_inclusive, color: AppColors.black),
        const SizedBox(width: 8),
        Text(
          AppTranslations.sundaySudoku,
          style: AppTypography.body.copyWith(color: AppColors.black),
        ),
      ],
    );
  }

  Widget _buildLives(BuildContext context) {
    final _lives = context.watch<GameProvider>().lives;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
          3,
          (int index) =>
              Icon(index < _lives ? Icons.favorite : Icons.favorite_outline),
        )
      ],
    );
  }

  Widget _buildNumbersKeyboard(BuildContext context) {
    final _watchProvider = context.watch<GameProvider>();
    final _buttonContentSize = DeviceUtil.isSmallDevice(context) ? 20.0 : 40.0;
    final _buttonMarginSize = DeviceUtil.isSmallDevice(context) ? 2.0 : 4.0;

    return Container(
      color: AppColors.keyboard,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(8),
      child: NonScrollableGridView(
          childAspectRatio: DeviceUtil.isSmallDevice(context) ? 3 / 2 : 1 / 1,
          crossAxisCount: 5,
          children: List<Widget>.generate(
            10,
            (int index) {
              final _number = ++index;
              final _canGameContinue = !_watchProvider.isWonRound &&
                  !_watchProvider.isGameOver &&
                  _watchProvider.selectedCell.coordinates!.isNotEmpty;

              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(_buttonMarginSize),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      border: Border.all(
                          color: AppColors.keyboardButtonText, width: 3),
                    ),
                    child: Material(
                      color: AppColors.keyboardButton,
                      child: InkWell(
                        onLongPress: _canGameContinue
                            ? () => _setMaybeNumber(context, _number)
                            : null,
                        onTap: _canGameContinue
                            ? () => _setNumber(context, _number)
                            : null,
                        child: Center(
                          child: _number < 10
                              ? Text(
                                  _number.toString(),
                                  style: AppTypography.body.copyWith(
                                    color: AppColors.keyboardButtonText,
                                    fontSize: _buttonContentSize,
                                  ),
                                )
                              : Icon(
                                  Icons.delete,
                                  color: AppColors.keyboardButtonText,
                                  size: _buttonContentSize,
                                ),
                        ),
                      ),
                    ),
                  ),
                  if (_number < 10)
                    Positioned(
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12, top: 8),
                        child: Text(
                          _number.toString(),
                          style: AppTypography.body.copyWith(
                            color: AppColors.keyboardButtonText,
                            fontSize: _buttonContentSize / 2.5,
                          ),
                        ),
                      ),
                    )
                ],
              );
            },
          )),
    );
  }

  void _setMaybeNumber(BuildContext context, int number) {
    context.read<GameProvider>().setMaybeNumber(
          maybeNumberInput: number < 10 ? number : -1,
          isDelete: number == 10,
        );
  }

  void _setNumber(BuildContext context, int number) {
    context.read<GameProvider>().setNumber(
          numberInput: number < 10 ? number : -1,
          isDelete: number == 10,
        );
  }
}
