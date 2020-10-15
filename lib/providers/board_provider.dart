import 'package:flutter/foundation.dart';
import 'package:sudoku_game/util/extensions.dart';

class BoardProvider with ChangeNotifier {
  static const initNumber = -1;

  @visibleForTesting
  bool isTesting = false;

  /**
   * Global variables for the [_initBoard] function
   */
  @visibleForTesting
  int i = 0;
  @visibleForTesting
  int j = 0;

  List<int> selectedCoordinates = [-1, -1];

  List<List<int>> _board;

  List<List<List<int>>> _availableNumbersForEveryTile =
      List.generate(9, (_) => List.generate(9, (_) => List()..refill()));

  @visibleForTesting
  List<List<int>> get board => _board;

  List<List<int>> get boardByGroup {
    return List.generate(9, (i) {
      return getCoordinates(i).map((e) => _board[e[0]][e[1]]).toList();
    });
  }

  int get latestGenerateTime => DateTime.now().millisecondsSinceEpoch - _timerStart;

  BoardProvider({bool isCalledFromTest = false}) {
    isTesting = isCalledFromTest;

    _restoreBoard();

    if (!isTesting) {
      buildBoard();
    }
  }

  void _restoreBoard() {
    i = 0;
    j = 0;
    _board = List<List<int>>.generate(9, (_) {
      return List<int>.generate(9, (_) {
        return BoardProvider.initNumber;
      });
    });
    notifyListeners();
  }

  @visibleForTesting
  void goNext() {
    if (j < 8) {
      j++;
    } else {
      i++;
      j = 0;
    }
  }

  @visibleForTesting
  void goPreviousAndClearNumber() {
    _board[i][j] = BoardProvider.initNumber;

    if (j > 0) {
      j--;
    } else {
      i--;
      j = 8;
    }
    // _bannedNumbers.add(_board[i][j]);
  }

  List<int> _bannedNumbers = [];
  int _timerStart = 0;

  void buildBoard() {
    // For some reason the board isn't being built successfully
    // unless called twice. Awaiting fix. Hopefully.
    _initBoard();
    // _initBoard();
  }

  Future<void> _initBoard() async {
    _restoreBoard();

    int _currentNumber() => _availableNumbersForEveryTile[i][j][0];

    while (!isBoardDoneBuilt()) {
      if (_availableNumbersForEveryTile[i][j].isEmpty) {
        _availableNumbersForEveryTile[i][j].refill();
        goPreviousAndClearNumber();
      } else {
        if (_isConflict(_currentNumber(), i, j)) {
          _availableNumbersForEveryTile[i][j].remove(_currentNumber());
        } else {
          _board[i][j] = _currentNumber();
          goNext();
        }
      }
    }

    if (!isTesting) {
      _removePositionsWithOnlyOneSolution();
    }
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
      int _oldNumber = _board[_currentPosition()[0]][_currentPosition()[1]];
      _board[_currentPosition()[0]][_currentPosition()[1]] = null;

      int _solutionCount = 0;

      for (int k = 1; k < 10; k++) {
        if (!_isConflict(k, _currentPosition()[0], _currentPosition()[1])) {
          _solutionCount++;
        }
      }
      assert(_solutionCount > 0);

      if (_solutionCount > 1) {
        _board[_currentPosition()[0]][_currentPosition()[1]] = _oldNumber;
      }

      _allPositions.removeAt(0);
    }

    notifyListeners();
  }

  bool isBoardDoneBuilt() {
    for (final list in _board) {
      for (final number in list) {
        if (number == BoardProvider.initNumber) return false;
      }
    }

    return true;
  }

  bool _isConflict(int num, int i, int j) {
    return boardByGroup[getGroupIndexOf(i, j)].where((e) => e == num).length >= 1 ||
        List.generate(9, (row) => _board[i][row]).where((e) => e == num).length >= 1 ||
        List.generate(9, (col) => _board[col][j]).where((e) => e == num).length >= 1;
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
  List<int> boardByRow(int row, int groupIndex) {
    if (groupIndex > 2 && groupIndex <= 5) {
      row += 3;
    } else if (groupIndex > 5) {
      row += 6;
    }

    return List.generate(9, (i) => _board[row][i]);
  }

  @visibleForTesting
  List<int> boardByColumn(int column, int groupIndex) {
    if (groupIndex == 1 || groupIndex == 4 || groupIndex == 7) {
      column += 3;
    } else if (groupIndex == 2 || groupIndex == 5 || groupIndex == 8) {
      column += 6;
    }

    return List.generate(9, (i) => _board[i][column]);
  }

  bool isOccupiedNumberInGroup({int index, int number, int groupIndex}) {
    return boardByGroup[groupIndex].where((int num) => num == number).length > 1 ||
        boardByRow(_getRowInGroup(index), groupIndex).where((int num) => num == number).length > 1 ||
        boardByColumn(_getColumnInGroup(index), groupIndex).where((int num) => num == number).length > 1;
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

  void setNumber(int number) {
    _board[selectedCoordinates[0]][selectedCoordinates[1]] = number;
    notifyListeners();
  }

  void setSelectedCoordinates(int groupIndex, int index) {
    selectedCoordinates = getCoordinates(groupIndex)[index];
    notifyListeners();
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
  void setBoard(List<List<int>> testBoard) {
    _board = testBoard;
  }
}
