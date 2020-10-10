class TestResources {
  static const List<List<int>> mockedValidBoard = [
    [4, 6, 9,    2, 3, 8,    5, 7, 1],
    [3, 8, 2,    1, 5, 7,    9, 6, 4],
    [5, 7, 1,    6, 9, 4,    2, 3, 8],

    [7, 3, 4,    5, 6, 1,    8, 2, 9],
    [8, 9, 5,    7, 2, 3,    1, 4, 6],
    [1, 2, 6,    4, 8, 9,    7, 5, 3],

    [6, 4, 7,    9, 1, 5,    3, 8, 2],
    [2, 1, 3,    8, 7, 6,    4, 9, 5],
    [9, 5, 8,    3, 4, 2,    6, 1, 7],
  ];

  static List<int> getExpectedBoardByRow(int row, int groupIndex) {
    if (groupIndex <= 2) {
      switch (row) {
        case 0:
          return [4, 6, 9, 2, 3, 8, 5, 7, 1];
        case 1:
          return [3, 8, 2, 1, 5, 7, 9, 6, 4];
        case 2:
          return [5, 7, 1, 6, 9, 4, 2, 3, 8];
      }
    } else if (groupIndex <= 5) {
      switch (row) {
        case 0:
          return [7, 3, 4, 5, 6, 1, 8, 2, 9];
        case 1:
          return [8, 9, 5, 7, 2, 3, 1, 4, 6];
        case 2:
          return [1, 2, 6, 4, 8, 9, 7, 5, 3];
      }
    } else if (groupIndex <= 8) {
      switch (row) {
        case 0:
          return [6, 4, 7, 9, 1, 5, 3, 8, 2];
        case 1:
          return [2, 1, 3, 8, 7, 6, 4, 9, 5];
        case 2:
          return [9, 5, 8, 3, 4, 2, 6, 1, 7];
      }
    }

    return List();
  }

  static List<int> getExpectedBoardByColumn(int column, int groupIndex) {
    if (groupIndex == 0 || groupIndex == 3 || groupIndex == 6) {
      switch (column) {
        case 0:
          return [4, 3, 5, 7, 8, 1, 6, 2, 9];
        case 1:
          return [6, 8, 7, 3, 9, 2, 4, 1, 5];
        case 2:
          return [9, 2, 1, 4, 5, 6, 7, 3, 8];
      }
    } else if (groupIndex == 1 || groupIndex == 4 || groupIndex == 7) {
      switch (column) {
        case 0:
          return [2, 1, 6, 5, 7, 4, 9, 8, 3];
        case 1:
          return [3, 5, 9, 6, 2, 8, 1, 7, 4];
        case 2:
          return [8, 7, 4, 1, 3, 9, 5, 6, 2];
      }
    } else if (groupIndex == 2 || groupIndex == 5 || groupIndex == 8) {
      switch (column) {
        case 0:
          return [5, 9, 2, 8, 1, 7, 3, 4, 6];
        case 1:
          return [7, 6, 3, 2, 4, 5, 8, 9, 1];
        case 2:
          return [1, 4, 8, 9, 6, 3, 2, 5, 7];
      }
    }

    return List();
  }

  static List<int> getExpectedBoardByGroup({int groupIndex}) {
    switch (groupIndex) {
      case 0:
        return [
          4, 6, 9,
          3, 8, 2,
          5, 7, 1
        ];
      case 1:
        return [
          2, 3, 8,
          1, 5, 7,
          6, 9, 4
        ];
      case 2:
        return [
          5, 7, 1,
          9, 6, 4,
          2, 3, 8
        ];
      case 3:
        return [
          7, 3, 4,
          8, 9, 5,
          1, 2, 6
        ];
      case 4:
        return [
          5, 6, 1,
          7, 2, 3,
          4, 8, 9
        ];
      case 5:
        return [
          8, 2, 9,
          1, 4, 6,
          7, 5, 3
        ];
      case 6:
        return [
          6, 4, 7,
          2, 1, 3,
          9, 5, 8
        ];
      case 7:
        return [
          9, 1, 5,
          8, 7, 6,
          3, 4, 2
        ];
      case 8:
        return [
          3, 8, 2,
          4, 9, 5,
          6, 1, 7
        ];
    }

    return List();
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
