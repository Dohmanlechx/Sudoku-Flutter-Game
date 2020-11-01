import 'package:sudoku_game/models/board.dart';
import 'package:sudoku_game/models/cell.dart';

extension IntListExtensions on Cell {
  void refillAvailableNumbers() => this.availableNumbers
    ..clear()
    ..addAll([1, 2, 3, 4, 5, 6, 7, 8, 9])
    ..shuffle();
}

extension BoardExtensions on Board {
  void clearAllTiles() => this.cells
    ..clear()
    ..addAll(List<List<Cell>>.generate(9, (_) => List.generate(9, (_) => Cell())));
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
}
