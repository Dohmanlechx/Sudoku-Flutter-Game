import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:sudoku_game/board/board_factory.dart';
import 'package:sudoku_game/board/board_solver.dart';
import 'package:sudoku_game/models/cell.dart';
import 'package:sudoku_game/util/device_util.dart';
import 'package:sudoku_game/util/extensions.dart';

enum Difficulty { easy, medium, hard }

class BoardProvider with ChangeNotifier {
  @visibleForTesting
  int i = 0;
  @visibleForTesting
  int j = 0;

  int _lives;

  Difficulty selectedDifficulty = Difficulty.easy;

  int get lives => _lives;

  bool get isGameOver => _lives <= 0;

  var _board = List<List<Cell>>()..clearAllTiles();

  @visibleForTesting
  List<List<Cell>> get board => _board;

  List<List<Cell>> get boardByGroup {
    return List.generate(9, (i) => BoardFactory.getGroupCoordinates(i).map((e) => _board[e[0]][e[1]]).toList());
  }

  Cell get selectedCell {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        final cell = _board[i][j];
        if (cell.isSelected) {
          return cell;
        }
      }
    }

    return Cell();
  }

  int get _currentNumber => _board[i][j].availableNumbers[0];

  bool get isWonRound {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (_board[i][j].number != _board[i][j].solutionNumber) {
          return false;
        }
      }
    }

    return true;
  }

  BoardProvider() {
    init(selectedDifficulty);
  }

  void init(Difficulty difficulty) {
    selectedDifficulty = difficulty;
    restoreRound();
    buildBoard(difficulty);
  }

  void buildBoard(Difficulty difficulty) async {
    _board.clearAllTiles();

    switch (difficulty) {
      case Difficulty.easy:
        {
          _fillBoardWithValidNumbers();
          _removeCellsWithOnlyOneSolution();
        }
        break;
      case Difficulty.medium:
        {
          _board = BoardFactory.mediumBoards[Random().nextInt(BoardFactory.mediumBoards.length - 1)];
          _board = BoardSolver(_board).getSolvedBoard();
        }
        break;
      case Difficulty.hard:
        {
          _board = BoardFactory.hardBoards[Random().nextInt(BoardFactory.hardBoards.length - 1)];
          _board = BoardSolver(_board).getSolvedBoard();
        }
        break;
    }

    notifyListeners();
  }

  void _fillBoardWithValidNumbers() {
    while (!isBoardFilled()) {
      if (_board[i][j].availableNumbers.isEmpty) {
        _board[i][j].refillAvailableNumbers();
        clearCurrentTileAndGoPrevious();
      } else {
        if (_isConflict(_currentNumber, i, j)) {
          _board[i][j].availableNumbers.remove(_currentNumber);
        } else {
          _board[i][j]
            ..number = _currentNumber
            ..solutionNumber = _currentNumber
            ..coordinates = [i, j];
          goNextTile();
        }
      }
    }
  }

  void _removeCellsWithOnlyOneSolution() {
    final List<Cell> _boardCopy = List.of(_board.expand((List<Cell> e) => e))..shuffle();

    while (_boardCopy.isNotEmpty) {
      int _oldNumber = _board[_boardCopy[0].i][_boardCopy[0].j].number;
      _board[_boardCopy[0].i][_boardCopy[0].j].number = null;

      int _solutionCount = 0;

      for (int k = 1; k < 10; k++) {
        if (!_isConflict(k, _boardCopy[0].i, _boardCopy[0].j)) {
          _solutionCount++;
        }
      }
      assert(_solutionCount > 0);

      if (_solutionCount > 1) {
        _board[_boardCopy[0].i][_boardCopy[0].j]
          ..number = _oldNumber
          ..isClickable = false;
      }

      _boardCopy.removeAt(0);
    }
  }

  @visibleForTesting
  void restoreRound() {
    _lives = 3;
    i = 0;
    j = 0;
  }

  @visibleForTesting
  void goNextTile() {
    assert(i < 9);
    if (j < 8) {
      j++;
    } else {
      i++;
      j = 0;
    }
  }

  @visibleForTesting
  void clearCurrentTileAndGoPrevious() {
    assert(i >= 0);
    _board[i][j].number = 0;

    if (j > 0) {
      j--;
    } else {
      i--;
      j = 8;
    }
  }

  bool isBoardFilled() {
    for (final List<Cell> row in _board) {
      for (final cell in row) {
        if (cell.isNotFilled) return false;
      }
    }

    return true;
  }

  bool isBoardFilledWithSolutions() {
    for (final List<Cell> row in _board) {
      for (final cell in row) {
        if (cell.solutionNumber == 0) return false;
      }
    }

    return true;
  }

  bool _isConflict(int num, int i, int j) {
    return boardByGroup[BoardFactory.getGroupIndexOf(i, j)].where((cell) => cell.number == num).length >= 1 ||
        List.generate(9, (row) => _board[i][row]).where((cell) => cell.number == num).length >= 1 ||
        List.generate(9, (col) => _board[col][j]).where((cell) => cell.number == num).length >= 1;
  }

  @visibleForTesting
  List<Cell> boardByRow(int row, int groupIndex) {
    if (groupIndex > 2 && groupIndex <= 5) {
      row += 3;
    } else if (groupIndex > 5) {
      row += 6;
    }

    return List.generate(9, (i) => _board[row][i]);
  }

  @visibleForTesting
  List<Cell> boardByColumn(int column, int groupIndex) {
    if (groupIndex == 1 || groupIndex == 4 || groupIndex == 7) {
      column += 3;
    } else if (groupIndex == 2 || groupIndex == 5 || groupIndex == 8) {
      column += 6;
    }

    return List.generate(9, (i) => _board[i][column]);
  }

  bool isOccupiedNumberInGroup({int index, int number, int groupIndex}) {
    return boardByGroup[groupIndex].where((cell) => cell.number == number).length > 1 ||
        boardByRow(BoardFactory.getRowInGroup(index), groupIndex).where((cell) => cell.number == number).length > 1 ||
        boardByColumn(BoardFactory.getColumnInGroup(index), groupIndex).where((cell) => cell.number == number).length >
            1;
  }

  void setNumber({int number, bool isDelete = false}) {
    final cell = _board[selectedCell.i][selectedCell.j]..number = number;

    if (cell.solutionNumber != number && !isDelete) {
      DeviceUtil.vibrate();
      _lives--;
    }

    notifyListeners();
  }

  void setSelectedCoordinates(int groupIndex, int index) {
    final _clickedCoordinates = BoardFactory.getGroupCoordinates(groupIndex)[index];
    final _clickedCell = _board[_clickedCoordinates[0]][_clickedCoordinates[1]];

    if (_clickedCell.isClickable) {
      _board.forEach((List<Cell> row) {
        return row.forEach((Cell cell) {
          cell.isSelected = false;
          cell.isHighlighted = false;
        });
      });

      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          final _isInThisRow = boardByRow(BoardFactory.getRowInGroup(index), groupIndex)
              .any((Cell cell) => listEquals([i, j], cell.coordinates));

          final _isInThisColumn = boardByColumn(BoardFactory.getColumnInGroup(index), groupIndex)
              .any((Cell cell) => listEquals([i, j], cell.coordinates));

          final _isInThisGroup = boardByGroup[groupIndex].any((Cell cell) => listEquals([i, j], cell.coordinates));

          if (_isInThisRow || _isInThisColumn || _isInThisGroup) {
            _board[i][j].isHighlighted = true;
          }
        }
      }

      _clickedCell.isSelected = true;
      notifyListeners();
    }
  }

  @visibleForTesting
  void setBoard(List<List<Cell>> testBoard) {
    _board = testBoard;
  }
}
