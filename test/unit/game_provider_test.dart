import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/board/board_factory.dart';
import 'package:sudoku_game/models/cell.dart';
import 'package:sudoku_game/providers/game_provider.dart';

import '../test_resources.dart';

void main() {
  GameProvider _newGameProvider() => GameProvider();

  test('The board should contain 81 elements', () {
    final board = _newGameProvider().board;
    var count = 0;

    for (final row in board) {
      row.forEach((_) => count++);
    }

    expect(count, 81);
  });

  test('The tileGroups should contain 9 elements', () {
    expect(BoardFactory.boardByGroup(_newGameProvider().board).length, 9);
  });

  test('boardByRow tests', () {
    BoardFactory.setBoard(TestResources.mockedValidBoard);

    final randomizer = Random();
    int testCount = 0;

    while (testCount <= 100) {
      final row = randomizer.nextInt(3);
      final groupIndex = randomizer.nextInt(9);

      final expected = TestResources.getExpectedBoardByRow(row, groupIndex);
      final actual = BoardFactory.boardByRow(row, groupIndex);

      expect(
        listEquals(
          actual.map((cell) => cell.number).toList(),
          expected.map((cell) => cell.number).toList(),
        ),
        isTrue,
      );

      testCount++;
    }
  });

  test('boardByColumn tests', () {
    BoardFactory.setBoard(TestResources.mockedValidBoard);

    final randomizer = Random();
    int testCount = 0;

    while (testCount <= 100) {
      final column = randomizer.nextInt(3);
      final groupIndex = randomizer.nextInt(9);

      final expected = TestResources.getExpectedBoardByColumn(column, groupIndex);
      final actual = BoardFactory.boardByColumn(column, groupIndex);

      expect(
        listEquals(
          actual.map((cell) => cell.number).toList(),
          expected.map((cell) => cell.number).toList(),
        ),
        isTrue,
      );

      testCount++;
    }
  });

  test('getGroupIndexOf tests', () {
    final Map<int, int> tests = {
      0: BoardFactory.getGroupIndexOf(1, 2),
      1: BoardFactory.getGroupIndexOf(2, 4),
      2: BoardFactory.getGroupIndexOf(0, 8),
      3: BoardFactory.getGroupIndexOf(4, 0),
      4: BoardFactory.getGroupIndexOf(4, 5),
      5: BoardFactory.getGroupIndexOf(5, 8),
      6: BoardFactory.getGroupIndexOf(7, 2),
      7: BoardFactory.getGroupIndexOf(6, 4),
      8: BoardFactory.getGroupIndexOf(8, 8)
    };

    tests.forEach((expected, actual) {
      expect(actual, expected);
    });
  });

  test('boardByGroup tests', () {
    for (int i = 0; i < 9; i++) {
      final actual = BoardFactory.boardByGroup(TestResources.mockedValidBoard)[i];
      final expected = TestResources.getExpectedBoardByGroup(groupIndex: i);

      expect(
        listEquals(
          actual.map((cell) => cell.number).toList(),
          expected.map((cell) => cell.number).toList(),
        ),
        isTrue,
      );
    }
  });

  test('goNext tests', () {
    BoardFactory.i = 0;
    BoardFactory.j = 0;
    BoardFactory.goNextTile();

    expect(BoardFactory.i, 0);
    expect(BoardFactory.j, 1);

    BoardFactory.i = 6;
    BoardFactory.j = 8;

    BoardFactory.goNextTile();

    expect(BoardFactory.i, 7);
    expect(BoardFactory.j, 0);
  });

  test('goPrevious tests', () {
    BoardFactory.i = 3;
    BoardFactory.j = 5;

    BoardFactory.clearCurrentTileAndGoPrevious();

    expect(BoardFactory.i, 3);
    expect(BoardFactory.j, 4);

    BoardFactory.i = 8;
    BoardFactory.j = 0;

    BoardFactory.clearCurrentTileAndGoPrevious();

    expect(BoardFactory.i, 7);
    expect(BoardFactory.j, 8);
  });

  test('Check if board is completely filled', () {
    final testBoard = List<List<Cell>>.generate(9, (_) {
      return List<Cell>.generate(9, (_) {
        return Cell(number: 1);
      });
    });

    BoardFactory.setBoard(testBoard);

    expect(BoardFactory.isBoardFilled(), true);
  });

  test('Check if it returns false when the board is not completely filled', () {
    final testBoard = List<List<Cell>>.generate(9, (_) {
      return List<Cell>.generate(9, (_) {
        return Cell(number: 1);
      });
    });

    testBoard[8][8].number = 0;

    BoardFactory.setBoard(testBoard);

    expect(BoardFactory.isBoardFilled(), false);
  });

  test('getCoordinates test', () {
    for (int i = 0; i < 9; i++) {
      expect(
        BoardFactory.getGroupCoordinates(i),
        TestResources.getExpectedOf(groupIndex: i),
      );
    }
  });
}
