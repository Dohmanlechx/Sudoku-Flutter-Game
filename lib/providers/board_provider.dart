import 'package:flutter/foundation.dart';

class BoardProvider with ChangeNotifier {
  List<List<int>> _board;

  List<List<int>> get board => _board;

  List<List<int>> get boardByGroup {
    return List.generate(9, (i) {
      return getCoordinates(i).map((e) => board[e[0]][e[1]]).toList();
    });
  }

  BoardProvider() {
    _initBoard();
  }

  void _initBoard() {
    _board = List<List<int>>.generate(9, (_) {
      return List<int>.generate(9, (_) {
        return 0;
      });
    });

    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        final groupIndex = getGroupIndexOf(i, j);
        var shuffledNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle();

        while (shuffledNumbers.isNotEmpty) {
          getCoordinates(groupIndex).forEach((List<int> pos) {
            _board[pos[0]][pos[1]] = shuffledNumbers[0];
            shuffledNumbers.removeAt(0);
          });
        }
      }
    }
  }

  void setNumber({int groupIndex, int index, int number}) {
    final coordinates = getCoordinates(groupIndex)[index];
    _board[coordinates[0]][coordinates[1]] = number;
    notifyListeners();
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

  List<int> boardByRow(int row, int groupIndex) {
    if (groupIndex > 2 && groupIndex <= 5) {
      row += 3;
    } else if (groupIndex > 5) {
      row += 6;
    }

    return List.generate(9, (i) => _board[row][i]);
  }

  List<int> boardByColumn(int column, int groupIndex) {
    if (groupIndex == 1 || groupIndex == 4 || groupIndex == 7) {
      column += 3;
    } else if (groupIndex == 3 || groupIndex == 5 || groupIndex == 8) {
      column += 6;
    }

    return List.generate(9, (i) => _board[i][column]);
  }

  bool isOccupiedNumber({int index, int number, int groupIndex}) {
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
}
