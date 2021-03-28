import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sudoku_game/board/board_factory.dart';
import 'package:sudoku_game/internal_storage.dart';
import 'package:sudoku_game/models/board.dart';
import 'package:sudoku_game/models/cell.dart';
import 'package:sudoku_game/util/device_util.dart';

enum Difficulty { easy, medium, hard, extreme }

class GameProvider with ChangeNotifier {
  static var isTesting = false;

  var _board = Board();

  Board get board => _board;

  int _lives = 0;

  int get lives => _lives;

  Difficulty _selectedDifficulty = Difficulty.easy;

  Difficulty get selectedDifficulty => _selectedDifficulty;

  final _isNewGameStream = BehaviorSubject<bool>();
  final _isRoundDoneStream = BehaviorSubject<bool>();

  Stream<bool> get isNewGameStream => _isNewGameStream.stream.asBroadcastStream();

  Stream<bool> get isRoundDoneStream => _isRoundDoneStream.stream.asBroadcastStream();

  Cell get selectedCell {
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        final cell = _board.cells[i][j];
        if (cell.isSelected == true) {
          return cell;
        }
      }
    }

    return Cell();
  }

  bool get isGameOver {
    var _isGameOver = _lives <= 0;
    if (_isGameOver) _isRoundDoneStream.add(true);
    return _isGameOver;
  }

  bool get isWonRound {
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        if (_board.cells[i][j].number != _board.cells[i][j].solutionNumber) {
          return false;
        }
      }
    }

    _isRoundDoneStream.add(true);
    return true;
  }

  GameProvider() {
    init(_selectedDifficulty);
  }

  bool get hasBeenStartedPlaying => _board.hasBeenStartedPlaying;

  void init(Difficulty difficulty, {bool isCalledByNewGame = false}) async {
    _isNewGameStream.add(true);

    _lives = 3;
    _selectedDifficulty = difficulty;

    if (isCalledByNewGame) {
      if (!isTesting) {
        await InternalStorage.clearGameSessionData();
        await InternalStorage.storeDifficulty(_selectedDifficulty);
      }

      _isNewGameStream.add(true);
      buildBoard(difficulty);
    } else {
      Board? _retrievedBoard;

      if (!isTesting) {
        _retrievedBoard = await InternalStorage.retrieveBoard();
      }

      if (_retrievedBoard != null) {
        _board = _retrievedBoard;

        BoardFactory.setBoard(_board);

        if (!isTesting) {
          _lives = await InternalStorage.retrieveLives();
          _selectedDifficulty = await InternalStorage.retrieveDifficulty() ?? Difficulty.easy;
        }

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
      case Difficulty.extreme:
        _board = BoardFactory.buildExtremeBoard();
        break;
    }

    if (!isTesting) {
      await InternalStorage.storeBoard(_board);
    }

    notifyListeners();
  }

  bool isOccupiedNumberInGroup({
    required int index,
    required int number,
    required int groupIndex,
  }) {
    return BoardFactory.isOccupiedNumberInGroup(index, number, groupIndex);
  }

  Future<void> setMaybeNumber({required int maybeNumberInput, isDelete = false}) async {
    final _clickedCell = _board.cells[selectedCell.i][selectedCell.j];

    if (_clickedCell.isFilled || maybeNumberInput == -1) return;

    await DeviceUtil.vibrate(ms: 10);

    if (_clickedCell.maybeNumbers?.contains(maybeNumberInput) == true) {
      _clickedCell.maybeNumbers?.remove(maybeNumberInput);
      notifyListeners();
      return;
    }

    _clickedCell.maybeNumbers?.add(maybeNumberInput);

    await InternalStorage.storeBoard(_board);
    notifyListeners();
  }

  Future<void> setNumber({required int numberInput, bool isDelete = false}) async {
    final _clickedCell = _board.cells[selectedCell.i][selectedCell.j];

    if (_clickedCell.number == _clickedCell.solutionNumber || numberInput == -1) return;

    _clickedCell.number = numberInput;
    _clickedCell.maybeNumbers?.clear();

    if (_clickedCell.solutionNumber != numberInput && !isDelete) {
      await DeviceUtil.vibrate(ms: 100);

      if (!InternalStorage.isSundayModeEnabled) {
        _lives--;
        await InternalStorage.storeLives(_lives);
      }
    }

    _board.hasBeenStartedPlaying = true;
    await InternalStorage.storeBoard(_board);
    notifyListeners();
  }

  void setSelectedCoordinates(int groupIndex, int index) {
    final _clickedCoordinates = BoardFactory.getGroupCoordinates(groupIndex)[index];
    final _clickedCell = _board.cells[_clickedCoordinates[0]][_clickedCoordinates[1]];

    if (_clickedCell.number == _clickedCell.solutionNumber) return;

    if (_clickedCell.isClickable == true) {
      _board.cells.forEach((List<Cell> row) {
        return row.forEach((Cell cell) {
          cell.isSelected = false;
          cell.isHighlighted = false;
        });
      });

      for (var i = 0; i < 9; i++) {
        for (var j = 0; j < 9; j++) {
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
