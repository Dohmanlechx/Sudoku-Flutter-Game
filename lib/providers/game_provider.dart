import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sudoku_game/board/board_factory.dart';
import 'package:sudoku_game/internal_storage.dart';
import 'package:sudoku_game/models/board.dart';
import 'package:sudoku_game/models/cell.dart';
import 'package:sudoku_game/util/device_util.dart';

enum Difficulty { easy, medium, hard }

class GameProvider with ChangeNotifier {
  var _board = Board();

  Board get board => _board;

  int _lives;

  int get lives => _lives;

  Difficulty _selectedDifficulty = Difficulty.easy;

  Difficulty get selectedDifficulty => _selectedDifficulty;

  var _isNewGameStream = StreamController<bool>();

  Stream<bool> get isNewGameStream => _isNewGameStream.stream.asBroadcastStream();

  Cell get selectedCell {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        final cell = _board.cells[i][j];
        if (cell.isSelected) {
          return cell;
        }
      }
    }

    return Cell();
  }

  bool get isGameOver {
    return _lives <= 0;
  }

  bool get isWonRound {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (_board.cells[i][j].number != _board.cells[i][j].solutionNumber) {
          return false;
        }
      }
    }

    return true;
  }

  GameProvider() {
    init(_selectedDifficulty);
  }

  void init(Difficulty difficulty, {bool isCalledByNewGame = false}) async {
    _isNewGameStream.add(true);

    _lives = 3;
    _selectedDifficulty = difficulty;

    if (isCalledByNewGame) {
      await InternalStorage.clearAllData();
      await InternalStorage.storeDifficulty(_selectedDifficulty);
      buildBoard(difficulty);
    } else {
      final Board _retrievedBoard = await InternalStorage.retrieveBoard();

      if (_retrievedBoard != null) {
        _board = _retrievedBoard;

        BoardFactory.setBoard(_board);

        _lives = await InternalStorage.retrieveLives();
        _selectedDifficulty = await InternalStorage.retrieveDifficulty();

        notifyListeners();
      } else {
        buildBoard(difficulty);
      }
    }
  }

  void buildBoard(Difficulty difficulty) async {
    _board.clearAllTiles();

    switch (difficulty) {
      case Difficulty.easy:
        _board = BoardFactory.buildEasyBoard();
        break;
      case Difficulty.medium:
        _board = BoardFactory.buildMediumBoard();
        break;
      case Difficulty.hard:
        _board = BoardFactory.buildHardBoard();
        break;
    }

    InternalStorage.storeBoard(_board);
    notifyListeners();
  }

  bool isOccupiedNumberInGroup({int index, int number, int groupIndex}) {
    return BoardFactory.isOccupiedNumberInGroup(index, number, groupIndex);
  }

  Future<void> setNumber({int number, bool isDelete = false}) async {
    final cell = _board.cells[selectedCell.i][selectedCell.j]..number = number;

    if (cell.solutionNumber != number && !isDelete) {
      DeviceUtil.vibrate();
      _lives--;
      await InternalStorage.storeLives(_lives);
    }

    InternalStorage.storeBoard(_board);
    notifyListeners();
  }

  void setSelectedCoordinates(int groupIndex, int index) {
    final _clickedCoordinates = BoardFactory.getGroupCoordinates(groupIndex)[index];
    final _clickedCell = _board.cells[_clickedCoordinates[0]][_clickedCoordinates[1]];

    if (_clickedCell.isClickable) {
      _board.cells.forEach((List<Cell> row) {
        return row.forEach((Cell cell) {
          cell.isSelected = false;
          cell.isHighlighted = false;
        });
      });

      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          _maybeHighlightThisCell(groupIndex, index, i, j);
        }
      }

      _clickedCell.isSelected = true;

      notifyListeners();
    }
  }

  void _maybeHighlightThisCell(int groupIndex, int index, int i, int j) {
    final _isInThisRow = BoardFactory.cellsByRow(BoardFactory.getRowInGroup(index), groupIndex)
        .any((Cell cell) => listEquals([i, j], cell.coordinates));

    final _isInThisColumn = BoardFactory.cellsByColumn(BoardFactory.getColumnInGroup(index), groupIndex)
        .any((Cell cell) => listEquals([i, j], cell.coordinates));

    final _isInThisGroup =
        BoardFactory.cellsByGroup(_board)[groupIndex].any((Cell cell) => listEquals([i, j], cell.coordinates));

    if (_isInThisRow || _isInThisColumn || _isInThisGroup) {
      _board.cells[i][j].isHighlighted = true;
    }
  }
}
