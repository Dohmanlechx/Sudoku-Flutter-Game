import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/providers/board_provider.dart';

void main() {
  test('Board should contain 81 elements', () {
    final List<List<int>> board = BoardProvider().list;
    var count = 0;

    for (final row in board) {
      row.forEach((_) => count++);
    }

    expect(count, 81);
  });
}
