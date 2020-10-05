import 'package:flutter/foundation.dart';

class BoardProvider with ChangeNotifier {
  List<List<int>> _board;

  List<List<int>> get board => _board;

  BoardProvider() {
    _initBoard();
  }

  void _initBoard() {
    _board = List<List<int>>.generate(9, (int a) {
      return List<int>.generate(9, (int b) {
        return 0;
      });
    });

    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        final groupIndex = getIndexOf(i, j);
        var shuffledNumber = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle();

        while (shuffledNumber.isNotEmpty) {
          positions(groupIndex).forEach((List<int> position) {
            _board[position[0]][position[1]] = shuffledNumber[0];
            shuffledNumber.removeAt(0);
          });
        }
      }
    }
  }

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

  List<List<int>> positions(int pointer) {
    switch (pointer) {
      case 0:
        return [
          [0, 0],
          [0, 1],
          [0, 2],
          [1, 0],
          [1, 1],
          [1, 2],
          [2, 0],
          [2, 1],
          [2, 2],
        ];
      case 1:
        return [
          [0, 3],
          [0, 4],
          [0, 5],
          [1, 3],
          [1, 4],
          [1, 5],
          [2, 3],
          [2, 4],
          [2, 5],
        ];
      case 2:
        return [
          [0, 6],
          [0, 7],
          [0, 8],
          [1, 6],
          [1, 7],
          [1, 8],
          [2, 6],
          [2, 7],
          [2, 8],
        ];
      case 3:
        return [
          [3, 0],
          [3, 1],
          [3, 2],
          [4, 0],
          [4, 1],
          [4, 2],
          [5, 0],
          [5, 1],
          [5, 2],
        ];
      case 4:
        return [
          [3, 3],
          [3, 4],
          [3, 5],
          [4, 3],
          [4, 4],
          [4, 5],
          [5, 3],
          [5, 4],
          [5, 5],
        ];
      case 5:
        return [
          [3, 6],
          [3, 7],
          [3, 8],
          [4, 6],
          [4, 7],
          [4, 8],
          [5, 6],
          [5, 7],
          [5, 8],
        ];
      case 6:
        return [
          [6, 0],
          [6, 1],
          [6, 2],
          [7, 0],
          [7, 1],
          [7, 2],
          [8, 0],
          [8, 1],
          [8, 2],
        ];
      case 7:
        return [
          [6, 3],
          [6, 4],
          [6, 5],
          [7, 3],
          [7, 4],
          [7, 5],
          [8, 3],
          [8, 4],
          [8, 5],
        ];
      case 8:
        return [
          [6, 6],
          [6, 7],
          [6, 8],
          [7, 6],
          [7, 7],
          [7, 8],
          [8, 6],
          [8, 7],
          [8, 8],
        ];
      default:
        throw Exception();
    }
  }

  List<List<int>> get boardByGroup {
    // TODO: Refactor and create test
    return [
      // 0
      [
        board[0][0],
        board[0][1],
        board[0][2],
        board[1][0],
        board[1][1],
        board[1][2],
        board[2][0],
        board[2][1],
        board[2][2],
      ],
      // 1
      [
        board[0][3],
        board[0][4],
        board[0][5],
        board[1][3],
        board[1][4],
        board[1][5],
        board[2][3],
        board[2][4],
        board[2][5],
      ],
      // 2
      [
        board[0][6],
        board[0][7],
        board[0][8],
        board[1][6],
        board[1][7],
        board[1][8],
        board[2][6],
        board[2][7],
        board[2][8],
      ],
      // 3
      [
        board[3][0],
        board[3][1],
        board[3][2],
        board[4][0],
        board[4][1],
        board[4][2],
        board[5][0],
        board[5][1],
        board[5][2],
      ],
      // 4
      [
        board[3][3],
        board[3][4],
        board[3][5],
        board[4][3],
        board[4][4],
        board[4][5],
        board[5][3],
        board[5][4],
        board[5][5],
      ],
      // 5
      [
        board[3][6],
        board[3][7],
        board[3][8],
        board[4][6],
        board[4][7],
        board[4][8],
        board[5][6],
        board[5][7],
        board[5][8],
      ],
      // 6
      [
        board[6][0],
        board[6][1],
        board[6][2],
        board[7][0],
        board[7][1],
        board[7][2],
        board[8][0],
        board[8][1],
        board[8][2],
      ],
      // 7
      [
        board[6][3],
        board[6][4],
        board[6][5],
        board[7][3],
        board[7][4],
        board[7][5],
        board[8][3],
        board[8][4],
        board[8][5],
      ],
      // 8
      [
        board[6][6],
        board[6][7],
        board[6][8],
        board[7][6],
        board[7][7],
        board[7][8],
        board[8][6],
        board[8][7],
        board[8][8],
      ],
    ];
  }
}
