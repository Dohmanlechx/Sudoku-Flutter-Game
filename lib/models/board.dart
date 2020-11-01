import 'package:sudoku_game/models/cell.dart';
import 'package:sudoku_game/util/extensions.dart';

class Board {
  Board() {
    cells = List();
    clearAllTiles();
  }

  List<List<Cell>> cells;
}
