import 'package:flutter/foundation.dart';
import 'package:sudoku_game/models/board.dart';
import 'package:sudoku_game/providers/game_provider.dart';
import 'package:test/test.dart';

void main() {
  Board _getNewBoard() => GameProvider().board;

  test('Board serialization and de-serialization', () {
    final Board _board = _getNewBoard();
    final String _boardJson = _board.toJson();
    final Board _boardFromJson = _boardJson.fromJson();

    expect(listEquals(_board.cells, _boardFromJson.cells), isTrue);
  });
}