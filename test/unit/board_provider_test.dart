import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/providers/board_provider.dart';

import '../test_resources.dart';

void main() {
  BoardProvider _newBoardProvider() => BoardProvider();

  test('The board should contain 81 elements', () {
    final board = _newBoardProvider().board;
    var count = 0;

    for (final row in board) {
      row.forEach((_) => count++);
    }

    expect(count, 81);
  });

  test('The tileGroups should contain 9 elements', () {
    expect(_newBoardProvider().boardByGroup.length, 9);
  });

  test('boardByRow tests', () {
    final provider = _newBoardProvider();

    provider.setBoard(TestResources.mockedValidBoard);

    final randomizer = Random();
    int testCount = 0;

    while (testCount <= 100) {
      final row = randomizer.nextInt(3);
      final groupIndex = randomizer.nextInt(9);

      final expected = TestResources.getExpectedBoardByRow(row, groupIndex);
      final actual = provider.boardByRow(row, groupIndex);

      expect(actual, expected);
      testCount++;
    }
  });

  test('boardByColumn tests', () {
    final provider = _newBoardProvider();

    provider.setBoard(TestResources.mockedValidBoard);

    final randomizer = Random();
    int testCount = 0;

    while (testCount <= 100) {
      final column = randomizer.nextInt(3);
      final groupIndex = randomizer.nextInt(9);

      final expected = TestResources.getExpectedBoardByColumn(column, groupIndex);
      final actual = provider.boardByColumn(column, groupIndex);

      expect(actual, expected);
      testCount++;
    }
  });

  test('getGroupIndexOf tests', () {
    final provider = _newBoardProvider();

    final Map<int, int> tests = {
      0: provider.getGroupIndexOf(1, 2),
      1: provider.getGroupIndexOf(2, 4),
      2: provider.getGroupIndexOf(0, 8),
      3: provider.getGroupIndexOf(4, 0),
      4: provider.getGroupIndexOf(4, 5),
      5: provider.getGroupIndexOf(5, 8),
      6: provider.getGroupIndexOf(7, 2),
      7: provider.getGroupIndexOf(6, 4),
      8: provider.getGroupIndexOf(8, 8)
    };

    tests.forEach((expected, actual) {
      expect(actual, expected);
    });
  });

  test('boardByGroup tests', () {
    final provider = _newBoardProvider();

    provider.setBoard(TestResources.mockedValidBoard);

    for (int i = 0; i < 9; i++) {
      expect(
        provider.boardByGroup[i],
        TestResources.getExpectedBoardByGroup(groupIndex: i),
      );
    }
  });

  test('goNext tests', () {
    final provider = _newBoardProvider();

    provider.restoreCurrentIndexes();
    provider.goNextTile();

    expect(provider.i, 0);
    expect(provider.j, 1);

    provider.i = 6;
    provider.j = 8;

    provider.goNextTile();

    expect(provider.i, 7);
    expect(provider.j, 0);
  });

  test('goPrevious tests', () {
    final provider = _newBoardProvider();

    provider.i = 3;
    provider.j = 5;

    provider.clearCurrentTileAndGoPrevious();

    expect(provider.i, 3);
    expect(provider.j, 4);

    provider.i = 8;
    provider.j = 0;

    provider.clearCurrentTileAndGoPrevious();

    expect(provider.i, 7);
    expect(provider.j, 8);
  });

  test('Check if board is completely filled', () {
    final provider = _newBoardProvider();

    final testBoard = List<List<int>>.generate(9, (_) {
      return List<int>.generate(9, (_) {
        return 1;
      });
    });

    provider.setBoard(testBoard);

    expect(provider.isBoardFilled(), true);
  });

  test('Check if it returns false when the board is not completely filled', () {
    final provider = _newBoardProvider();

    final testBoard = List<List<int>>.generate(9, (_) {
      return List<int>.generate(9, (_) {
        return 1;
      });
    });

    testBoard[8][8] = 0;

    provider.setBoard(testBoard);

    expect(provider.isBoardFilled(), false);
  });

  test('getCoordinates test', () {
    final provider = _newBoardProvider();

    for (int i = 0; i < 9; i++) {
      expect(
        provider.getCoordinates(i),
        TestResources.getExpectedOf(groupIndex: i),
      );
    }
  });
}
