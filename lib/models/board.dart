import 'package:sudoku_game/models/cell.dart';

class Board {
  Board() {
    cells = List();
    clearAllTiles();
  }

  List<List<Cell>> cells;

  void clearAllTiles() {
    this.cells
      ..clear()
      ..addAll(List<List<Cell>>.generate(9, (_) => List.generate(9, (_) => Cell())));
  }
}
