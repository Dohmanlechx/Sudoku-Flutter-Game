import 'package:flutter/foundation.dart';

class BoardProvider with ChangeNotifier {
  List<List<int>> _board;

  List<List<int>> get board => _board;

  List<List<int>> get boardByGroup {
    return List.generate(9, (index) {
      return coordinates(index).map((e) => board[e[0]][e[1]]).toList();
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
        final groupIndex = getIndexOf(i, j);
        var shuffledNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle();

        while (shuffledNumbers.isNotEmpty) {
          coordinates(groupIndex).forEach((List<int> pos) {
            _board[pos[0]][pos[1]] = shuffledNumbers[0];
            shuffledNumbers.removeAt(0);
          });
        }
      }
    }
  }

  @visibleForTesting
  int getIndexOf(int a, int b) {
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

  List<List<int>> coordinates(int pointer) {
    var res = List<List<int>>();

    switch (pointer) {
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
