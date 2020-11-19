import 'package:flutter/material.dart';
import 'package:sudoku_game/models/board.dart';
import 'package:sudoku_game/models/cell.dart';
import 'package:sudoku_game/providers/game_provider.dart';

const _difficultyMap = {
  Difficulty.easy: 'easy',
  Difficulty.medium: 'medium',
  Difficulty.hard: 'hard',
  Difficulty.extreme: 'extreme',
};

extension IntListExtensions on Cell {
  void refillAvailableNumbers() => this.availableNumbers
    ..clear()
    ..addAll([1, 2, 3, 4, 5, 6, 7, 8, 9])
    ..shuffle();
}

extension StringExtensions on String {
  Board toBoard() {
    return Board()
      ..cells = List.generate(9, (int i) {
        return List.generate(9, (int j) {
          final _number = int.parse(this[(i * 9) + j]);

          return Cell(
            number: _number,
            solutionNumber: _number,
            isClickable: _number <= 0,
            coordinates: [i, j],
          );
        });
      });
  }

  String capitalize() => this[0].toUpperCase() + this.substring(1).toLowerCase();

  Difficulty toDifficultyEnum() {
    Difficulty res;

    _difficultyMap.forEach((key, value) {
      if (res != null) return;
      if (this == value) res = key;
    });

    return res;
  }
}

extension DifficultyExtensions on Difficulty {
  String asString() => _difficultyMap[this];
}

extension ContextExtensions on BuildContext {
  bool isLightMode() => MediaQuery.of(this).platformBrightness == Brightness.light;
}
