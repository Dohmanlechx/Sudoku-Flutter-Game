import 'package:sudoku_game/models/cell.dart';

extension IntListExtensions on Cell {
  void refillAvailableNumbers() => this.availableNumbers
    ..clear()
    ..addAll([1, 2, 3, 4, 5, 6, 7, 8, 9])
    ..shuffle();
}

extension BoardExtensions on List<List<Cell>> {
  void clearAllTiles() => this
    ..clear()
    ..addAll(List<List<Cell>>.generate(9, (_) => List.generate(9, (_) => Cell())));
}

extension StringExtensions on String {
  List<List<Cell>> toBoard() {
    return List.generate(9, (int a) {
      return List.generate(9, (int b) {
        final _number = int.parse(this[(a * 9) + b]);
        return Cell(number: _number <= 0 ? null : _number, solutionNumber: _number);
      });
    });
  }
}
