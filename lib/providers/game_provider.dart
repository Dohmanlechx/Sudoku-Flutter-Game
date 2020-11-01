import 'package:flutter/foundation.dart';
import 'package:sudoku_game/board/board_factory.dart';
import 'package:sudoku_game/models/cell.dart';
import 'package:sudoku_game/util/device_util.dart';
import 'package:sudoku_game/util/extensions.dart';

enum Difficulty { easy, medium, hard }

class GameProvider with ChangeNotifier {
  List<List<Cell>> _board = List();

  List<List<Cell>> get board => _board;

  int _lives;

  int get lives => _lives;

  Difficulty _selectedDifficulty = Difficulty.easy;

  Difficulty get selectedDifficulty => _selectedDifficulty;

  Cell get selectedCell {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        final cell = _board[i][j];
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
        if (_board[i][j].number != _board[i][j].solutionNumber) {
          return false;
        }
      }
    }

    return true;
  }

  GameProvider() {
    init(_selectedDifficulty);
  }

  void init(Difficulty difficulty) {
    _selectedDifficulty = difficulty;
    _lives = 3;
    buildBoard(difficulty);
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

    notifyListeners();
  }

  bool isOccupiedNumberInGroup({int index, int number, int groupIndex}) {
    return BoardFactory.isOccupiedNumberInGroup(index, number, groupIndex);
  }

  void setNumber({int number, bool isDelete = false}) {
    final cell = _board[selectedCell.i][selectedCell.j]..number = number;

    if (cell.solutionNumber != number && !isDelete) {
      DeviceUtil.vibrate();
      _lives--;
    }

    notifyListeners();
  }

  void setSelectedCoordinates(int groupIndex, int index) {
    final _clickedCoordinates = BoardFactory.getGroupCoordinates(groupIndex)[index];
    final _clickedCell = _board[_clickedCoordinates[0]][_clickedCoordinates[1]];

    if (_clickedCell.isClickable) {
      _board.forEach((List<Cell> row) {
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
    final _isInThisRow = BoardFactory.boardByRow(BoardFactory.getRowInGroup(index), groupIndex)
        .any((Cell cell) => listEquals([i, j], cell.coordinates));

    final _isInThisColumn = BoardFactory.boardByColumn(BoardFactory.getColumnInGroup(index), groupIndex)
        .any((Cell cell) => listEquals([i, j], cell.coordinates));

    final _isInThisGroup =
        BoardFactory.boardByGroup(_board)[groupIndex].any((Cell cell) => listEquals([i, j], cell.coordinates));

    if (_isInThisRow || _isInThisColumn || _isInThisGroup) {
      _board[i][j].isHighlighted = true;
    }
  }
}
