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
