import 'package:sudoku_game/board/board_factory.dart';
import 'package:sudoku_game/models/board.dart';
import 'package:sudoku_game/models/cell.dart';
import 'package:sudoku_game/util/extensions.dart';

abstract class BoardSolver {
  static Board getSolvedBoard(Board board) {
    final _emptyCells =
        board.cells.expand((List<Cell> cells) => cells.where((Cell cell) => cell.solutionNumber! <= 0)).toList();

    var _iterator = 0;

    Cell _currentCell() => _emptyCells[_iterator];

    do {
      if (_currentCell().availableNumbers!.isEmpty) {
        _currentCell().refillAvailableNumbers();
        _currentCell().number = 0;
        _currentCell().solutionNumber = 0;
        _iterator--;
      } else {
        if (BoardFactory.isConflict(_currentCell().availableNumbers![0], _currentCell().i, _currentCell().j, board)) {
          _currentCell().availableNumbers!.remove(_currentCell().availableNumbers![0]);
        } else {
          board.cells[_currentCell().i][_currentCell().j].number = _currentCell().availableNumbers![0];
          board.cells[_currentCell().i][_currentCell().j].solutionNumber = _currentCell().availableNumbers![0];
          _iterator++;
        }
      }
    } while (_iterator < _emptyCells.length);

    _emptyCells.forEach((Cell cell) {
      board.cells[cell.i][cell.j].number = null;
    });

    return board;
  }
}
