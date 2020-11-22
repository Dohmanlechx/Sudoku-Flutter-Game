import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sudoku_game/board/board_factory.dart';
import 'package:sudoku_game/models/board.dart';
import 'package:sudoku_game/providers/game_provider.dart';
import 'package:test/test.dart';

void main() {
  Board _getNewBoard() {
    GameProvider.isTesting = true;
    return GameProvider().board;
  }

  test('Board serialization and de-serialization', () {
    List.generate(100, (_) => _getNewBoard()).forEach((Board board) {
      final Board _boardBeforeSerialization = board;
      final Map<String, dynamic> _boardSerialized = _boardBeforeSerialization.toJson();

      final String _boardJson = jsonEncode(_boardSerialized);

      final Map<String, dynamic> _boardDeserialized = jsonDecode(_boardJson);
      final Board _boardAfterSerialization = Board.fromJson(_boardDeserialized);

      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          expect(
            _boardBeforeSerialization.cells[i][j].number,
            _boardAfterSerialization.cells[i][j].number,
          );
          expect(
            _boardBeforeSerialization.cells[i][j].solutionNumber,
            _boardAfterSerialization.cells[i][j].solutionNumber,
          );
          expect(
            _boardBeforeSerialization.cells[i][j].isClickable,
            _boardAfterSerialization.cells[i][j].isClickable,
          );
          expect(
            _boardBeforeSerialization.cells[i][j].isSelected,
            _boardAfterSerialization.cells[i][j].isSelected,
          );
          expect(
            _boardBeforeSerialization.cells[i][j].isHighlighted,
            _boardAfterSerialization.cells[i][j].isHighlighted,
          );
          expect(
            listEquals(
              _boardBeforeSerialization.cells[i][j].coordinates,
              _boardAfterSerialization.cells[i][j].coordinates,
            ),
            isTrue,
          );
        }
      }
    });
  });

  test('Random generator should only emit a digit between 1 and 9', () {
    var count = 0;

    while (count < 100) {
      final randomizedDigit = BoardFactory.getRandomDigitOf(9);
      assert(randomizedDigit >= 1 && randomizedDigit <= 9);
      count++;
    }
  });
}
