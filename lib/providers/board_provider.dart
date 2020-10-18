import 'package:flutter/foundation.dart';
import 'package:sudoku_game/models/cell.dart';
import 'package:sudoku_game/util/device_util.dart';
import 'package:sudoku_game/util/extensions.dart';

class BoardProvider with ChangeNotifier {
  /**
   * Current global indexes
   */
  @visibleForTesting
  int i = 0;
  @visibleForTesting
  int j = 0;

  /**
   * The Main Board
   */
  var _board = List<List<Cell>>()..clearAllTiles();

  /**
   * Get currently selected cell
   */
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

  /**
   * Each cell holds all 1-9 numbers, shuffled
   * and are being removed if there's a conflict
   */
  int get _currentNumber => _board[i][j].availableNumbers[0];

  @visibleForTesting
  List<List<Cell>> get board => _board;

  List<List<Cell>> get boardByGroup {
    return List.generate(9, (i) => getCoordinates(i).map((e) => _board[e[0]][e[1]]).toList());
  }

  /**
   * Constructor
   */
  BoardProvider() {
    restoreCurrentIndexes();
    initBoard();
  }

  /**
   * Functions
   */
  @visibleForTesting
  void restoreCurrentIndexes() {
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

  void initBoard() async {
    restoreCurrentIndexes();
    _board.clearAllTiles();

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
          ;
          goNextTile();
        }
      }
    }

    _removePositionsWithOnlyOneSolution();
  }

  void _removePositionsWithOnlyOneSolution() {
    final List<List<int>> _allPositions = [];

    List<int> _currentPosition() => _allPositions[0];

    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        _allPositions.add([i, j]);
      }
    }

    _allPositions.shuffle();

    while (_allPositions.isNotEmpty) {
      int _oldNumber = _board[_currentPosition()[0]][_currentPosition()[1]].number;
      _board[_currentPosition()[0]][_currentPosition()[1]].number = null;

      int _solutionCount = 0;

      for (int k = 1; k < 10; k++) {
        if (!_isConflict(k, _currentPosition()[0], _currentPosition()[1])) {
          _solutionCount++;
        }
      }

      assert(_solutionCount > 0);

      if (_solutionCount > 1) {
        _board[_currentPosition()[0]][_currentPosition()[1]]
          ..number = _oldNumber
          ..isClickable = false;
      }

      _allPositions.removeAt(0);
    }

    notifyListeners();
  }

  bool isBoardFilled() {
    for (final List<Cell> cells in _board) {
      for (final cell in cells) {
        if (cell.isNotFilled) return false;
      }
    }

    return true;
  }

  bool _isConflict(int num, int i, int j) {
    return boardByGroup[getGroupIndexOf(i, j)].where((cell) => cell.number == num).length >= 1 ||
        List.generate(9, (row) => _board[i][row]).where((cell) => cell.number == num).length >= 1 ||
        List.generate(9, (col) => _board[col][j]).where((cell) => cell.number == num).length >= 1;
  }

  int _getRowInGroup(int i) {
    if (i <= 2) {
      return 0;
    } else if (i <= 5) {
      return 1;
    } else {
      return 2;
    }
  }

  int _getColumnInGroup(int i) {
    if (i == 0 || i == 3 || i == 6) {
      return 0;
    } else if (i == 1 || i == 4 || i == 7) {
      return 1;
    } else {
      return 2;
    }
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
        boardByRow(_getRowInGroup(index), groupIndex).where((cell) => cell.number == number).length > 1 ||
        boardByColumn(_getColumnInGroup(index), groupIndex).where((cell) => cell.number == number).length > 1;
  }

  @visibleForTesting
  int getGroupIndexOf(int a, int b) {
    int res;

    if (a >= 0 && a <= 2 && b >= 0 && b <= 2) {
      res = 0;
    } else if (a >= 0 && a <= 2 && b >= 3 && b <= 5) {
      res = 1;
    } else if (a >= 0 && a <= 2 && b >= 6 && b <= 8) {
      res = 2;
    } else if (a >= 3 && a <= 5 && b >= 0 && b <= 2) {
      res = 3;
    } else if (a >= 3 && a <= 5 && b >= 3 && b <= 5) {
      res = 4;
    } else if (a >= 3 && a <= 5 && b >= 6 && b <= 8) {
      res = 5;
    } else if (a >= 6 && a <= 8 && b >= 0 && b <= 2) {
      res = 6;
    } else if (a >= 6 && a <= 8 && b >= 3 && b <= 5) {
      res = 7;
    } else if (a >= 6 && a <= 8 && b >= 6 && b <= 8) {
      res = 8;
    }

    assert(res != null);
    return res;
  }

  void setNumber({int number, bool isDelete = false}) {
    final cell = _board[selectedCell.coordinates[0]][selectedCell.coordinates[1]]..number = number;

    if (cell.solutionNumber != number && !isDelete) {
      DeviceUtil.vibrate();
    }

    notifyListeners();
  }

  void setSelectedCoordinates(int groupIndex, int index) {
    final _clickedCoordinates = getCoordinates(groupIndex)[index];
    final _clickedCell = _board[_clickedCoordinates[0]][_clickedCoordinates[1]];

    if (_clickedCell.isClickable) {
      _board.forEach((List<Cell> row) {
        return row.forEach((Cell cell) {
          cell.isSelected = false;
        });
      });

      _clickedCell.isSelected = true;
      notifyListeners();
    }
  }

  List<List<int>> getCoordinates(int groupIndex) {
    var res = List<List<int>>();

    switch (groupIndex) {
      case 0:
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 3; j++) {
            res.add([i, j]);
          }
        }
        break;
      case 1:
        for (int i = 0; i < 3; i++) {
          for (int j = 3; j < 6; j++) {
            res.add([i, j]);
          }
        }
        break;
      case 2:
        for (int i = 0; i < 3; i++) {
          for (int j = 6; j < 9; j++) {
            res.add([i, j]);
          }
        }
        break;
      case 3:
        for (int i = 3; i < 6; i++) {
          for (int j = 0; j < 3; j++) {
            res.add([i, j]);
          }
        }
        break;
      case 4:
        for (int i = 3; i < 6; i++) {
          for (int j = 3; j < 6; j++) {
            res.add([i, j]);
          }
        }
        break;
      case 5:
        for (int i = 3; i < 6; i++) {
          for (int j = 6; j < 9; j++) {
            res.add([i, j]);
          }
        }
        break;
      case 6:
        for (int i = 6; i < 9; i++) {
          for (int j = 0; j < 3; j++) {
            res.add([i, j]);
          }
        }
        break;
      case 7:
        for (int i = 6; i < 9; i++) {
          for (int j = 3; j < 6; j++) {
            res.add([i, j]);
          }
        }
        break;
      case 8:
        for (int i = 6; i < 9; i++) {
          for (int j = 6; j < 9; j++) {
            res.add([i, j]);
          }
        }
        break;
    }

    return res;
  }

  @visibleForTesting
  void setBoard(List<List<Cell>> testBoard) {
    _board = testBoard;
  }
}
