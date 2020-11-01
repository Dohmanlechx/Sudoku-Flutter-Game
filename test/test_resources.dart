import 'package:sudoku_game/models/board.dart';
import 'package:sudoku_game/models/cell.dart';

class TestResources {
  static Board mockedValidBoard =
    Board()..cells = [
        [4, 6, 9,    2, 3, 8,    5, 7, 1],
        [3, 8, 2,    1, 5, 7,    9, 6, 4],
        [5, 7, 1,    6, 9, 4,    2, 3, 8],

        [7, 3, 4,    5, 6, 1,    8, 2, 9],
        [8, 9, 5,    7, 2, 3,    1, 4, 6],
        [1, 2, 6,    4, 8, 9,    7, 5, 3],

        [6, 4, 7,    9, 1, 5,    3, 8, 2],
        [2, 1, 3,    8, 7, 6,    4, 9, 5],
        [9, 5, 8,    3, 4, 2,    6, 1, 7],
    ].map((row) => row.map((int num) => Cell(number: num)).toList()).toList();

  static List<Cell> getExpectedBoardByRow(int row, int groupIndex) {
    List<int> res;

    if (groupIndex <= 2) {
      switch (row) {
        case 0:
          res = [4, 6, 9, 2, 3, 8, 5, 7, 1];
          break;
        case 1:
          res = [3, 8, 2, 1, 5, 7, 9, 6, 4];
          break;
        case 2:
          res = [5, 7, 1, 6, 9, 4, 2, 3, 8];
          break;
      }
    } else if (groupIndex <= 5) {
      switch (row) {
        case 0:
          res = [7, 3, 4, 5, 6, 1, 8, 2, 9];
          break;
        case 1:
          res = [8, 9, 5, 7, 2, 3, 1, 4, 6];
          break;
        case 2:
          res = [1, 2, 6, 4, 8, 9, 7, 5, 3];
          break;
      }
    } else if (groupIndex <= 8) {
      switch (row) {
        case 0:
          res = [6, 4, 7, 9, 1, 5, 3, 8, 2];
          break;
        case 1:
          res = [2, 1, 3, 8, 7, 6, 4, 9, 5];
          break;
        case 2:
          res = [9, 5, 8, 3, 4, 2, 6, 1, 7];
          break;
      }
    }

    return res.map((int num) => Cell(number: num)).toList();
  }

  static List<Cell> getExpectedBoardByColumn(int column, int groupIndex) {
    List<int> res;

    if (groupIndex == 0 || groupIndex == 3 || groupIndex == 6) {
      switch (column) {
        case 0:
          res = [4, 3, 5, 7, 8, 1, 6, 2, 9];
          break;
        case 1:
          res = [6, 8, 7, 3, 9, 2, 4, 1, 5];
          break;
        case 2:
          res = [9, 2, 1, 4, 5, 6, 7, 3, 8];
          break;
      }
    } else if (groupIndex == 1 || groupIndex == 4 || groupIndex == 7) {
      switch (column) {
        case 0:
          res = [2, 1, 6, 5, 7, 4, 9, 8, 3];
          break;
        case 1:
          res = [3, 5, 9, 6, 2, 8, 1, 7, 4];
          break;
        case 2:
          res = [8, 7, 4, 1, 3, 9, 5, 6, 2];
          break;
      }
    } else if (groupIndex == 2 || groupIndex == 5 || groupIndex == 8) {
      switch (column) {
        case 0:
          res = [5, 9, 2, 8, 1, 7, 3, 4, 6];
          break;
        case 1:
          res = [7, 6, 3, 2, 4, 5, 8, 9, 1];
          break;
        case 2:
          res = [1, 4, 8, 9, 6, 3, 2, 5, 7];
          break;
      }
    }

    return res.map((int num) => Cell(number: num)).toList();
  }

  static List<Cell> getExpectedBoardByGroup({int groupIndex}) {
    List<int> res;

    switch (groupIndex) {
      case 0:
        res = [
          4, 6, 9,
          3, 8, 2,
          5, 7, 1
        ];
        break;
      case 1:
        res = [
          2, 3, 8,
          1, 5, 7,
          6, 9, 4
        ];
        break;
      case 2:
        res = [
          5, 7, 1,
          9, 6, 4,
          2, 3, 8
        ];
        break;
      case 3:
        res = [
          7, 3, 4,
          8, 9, 5,
          1, 2, 6
        ];
        break;
      case 4:
        res = [
          5, 6, 1,
          7, 2, 3,
          4, 8, 9
        ];
        break;
      case 5:
        res = [
          8, 2, 9,
          1, 4, 6,
          7, 5, 3
        ];
        break;
      case 6:
        res = [
          6, 4, 7,
          2, 1, 3,
          9, 5, 8
        ];
        break;
      case 7:
        res = [
          9, 1, 5,
          8, 7, 6,
          3, 4, 2
        ];
        break;
      case 8:
        res = [
          3, 8, 2,
          4, 9, 5,
          6, 1, 7
        ];
        break;
    }

    return res.map((int num) => Cell(number: num)).toList();
  }

  static List<List<int>> getExpectedOf({int groupIndex}) {
    switch (groupIndex) {
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
    }

    return List();
  }
}
