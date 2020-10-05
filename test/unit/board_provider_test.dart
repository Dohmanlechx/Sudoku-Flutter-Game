import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/providers/board_provider.dart';

void main() {
  test('Board should contain 81 elements', () {
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
}
