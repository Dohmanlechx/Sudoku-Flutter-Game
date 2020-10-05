import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/providers/board_provider.dart';

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

  test('BoardGroup index tests', () {
    final provider = BoardProvider();

    const expected0 = 0;
    final actual0 = provider.getIndexOf(1, 2);

    const expected1 = 1;
    final actual1 = provider.getIndexOf(2, 4);

    const expected2 = 2;
    final actual2 = provider.getIndexOf(0, 8);

    const expected3 = 3;
    final actual3 = provider.getIndexOf(4, 0);

    const expected4 = 4;
    final actual4 = provider.getIndexOf(4, 5);

    const expected5 = 5;
    final actual5 = provider.getIndexOf(5, 8);

    const expected6 = 6;
    final actual6 = provider.getIndexOf(7, 2);

    const expected7 = 7;
    final actual7 = provider.getIndexOf(6, 4);

    const expected8 = 8;
    final actual8 = provider.getIndexOf(8, 8);

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
}
