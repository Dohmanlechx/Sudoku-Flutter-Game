import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/providers/board_provider.dart';
import 'package:sudoku_game/util/custom_exceptions.dart';

import '../test_resources.dart';

void main() {
  test('The board should contain 81 elements', () {
    final board = BoardProvider().board;
    var count = 0;

    for (final row in board) {
      row.forEach((_) => count++);
    }

    expect(count, 81);
  });

  test('The tileGroups should contain 9 elements', () {
    final boardByGroup = BoardProvider().boardByGroup;
    expect(boardByGroup.length, 9);
  });

  test('getGroupIndexOf tests', () {
    final provider = BoardProvider();

    const expected0 = 0;
    final actual0 = provider.getGroupIndexOf(1, 2);

    const expected1 = 1;
    final actual1 = provider.getGroupIndexOf(2, 4);

    const expected2 = 2;
    final actual2 = provider.getGroupIndexOf(0, 8);

    const expected3 = 3;
    final actual3 = provider.getGroupIndexOf(4, 0);

    const expected4 = 4;
    final actual4 = provider.getGroupIndexOf(4, 5);

    const expected5 = 5;
    final actual5 = provider.getGroupIndexOf(5, 8);

    const expected6 = 6;
    final actual6 = provider.getGroupIndexOf(7, 2);

    const expected7 = 7;
    final actual7 = provider.getGroupIndexOf(6, 4);

    const expected8 = 8;
    final actual8 = provider.getGroupIndexOf(8, 8);

    expect(actual0, expected0);
    expect(actual1, expected1);
    expect(actual2, expected2);
    expect(actual3, expected3);
    expect(actual4, expected4);
    expect(actual5, expected5);
    expect(actual6, expected6);
    expect(actual7, expected7);
    expect(actual8, expected8);
  });

  test('boardByGroup tests', () {
    final provider = BoardProvider();

    provider.setBoard(TestResources.mockedValidBoard);

    for (int i = 0; i < 9; i++) {
      expect(
        provider.boardByGroup[i],
        TestResources.getExpectedBoardByGroup(groupIndex: i),
      );
    }
  });

  test('goNext tests', () {
    final provider = BoardProvider();

    provider.goNext();

    expect(provider.i, 0);
    expect(provider.j, 1);

    provider.i = 6;
    provider.j = 8;

    provider.goNext();

    expect(provider.i, 7);
    expect(provider.j, 0);

    provider.i = 8;
    provider.j = 8;

    expect(provider.goNext, throwsA(isInstanceOf<IteratorException>()));
  });

  test('goPrevious tests', () {
    final provider = BoardProvider();

    provider.i = 3;
    provider.j = 5;

    provider.goPreviousAndClearNumber();

    expect(provider.i, 3);
    expect(provider.j, 4);

    provider.i = 8;
    provider.j = 0;

    provider.goPreviousAndClearNumber();

    expect(provider.i, 7);
    expect(provider.j, 8);

    provider.i = 0;
    provider.j = 0;

    expect(provider.goPreviousAndClearNumber, throwsA(isInstanceOf<IteratorException>()));
  });

  test('Check if board is completely filled', () {
    final provider = BoardProvider();

    final testBoard = List<List<int>>.generate(9, (_) {
      return List<int>.generate(9, (_) {
        return 1;
      });
    });

    provider.setBoard(testBoard);

    expect(provider.isBoardFilled(), true);
  });

  test('Check if it returns false when the board is not completely filled', () {
    final provider = BoardProvider();

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
    final provider = BoardProvider();

    for (int i = 0; i < 9; i++) {
      expect(
        provider.getCoordinates(i),
        TestResources.getExpectedOf(groupIndex: i),
      );
    }
  });
}
