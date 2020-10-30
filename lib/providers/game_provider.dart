import 'package:flutter/foundation.dart';
import 'package:sudoku_game/board/board_factory.dart';
import 'package:sudoku_game/models/cell.dart';
import 'package:sudoku_game/util/device_util.dart';
import 'package:sudoku_game/util/extensions.dart';

enum Difficulty { easy, medium, hard }

class GameProvider with ChangeNotifier {
  var _board = List<List<Cell>>();

  List<List<Cell>> get board => _board;

  int _lives;

  int get lives => _lives;

  var _selectedDifficulty = Difficulty.easy;

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
    restoreRound();
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

  @visibleForTesting
  void restoreRound() {
    _lives = 3;
  }

  @visibleForTesting
  List<Cell> boardByRow(int row, int groupIndex) {
    if (groupIndex > 2 && groupIndex <= 5) {
      row += 3;
    } else if (groupIndex > 5) {
      row += 6;
    }

    return List.generate(9, (i) => _board[row][i]);
  }

  @visibleForTesting
  List<Cell> boardByColumn(int column, int groupIndex) {
    if (groupIndex == 1 || groupIndex == 4 || groupIndex == 7) {
      column += 3;
    } else if (groupIndex == 2 || groupIndex == 5 || groupIndex == 8) {
      column += 6;
    }

    return List.generate(9, (i) => _board[i][column]);
  }

  bool isOccupiedNumberInGroup({int index, int number, int groupIndex}) {
    return BoardFactory.boardByGroup(_board)[groupIndex].where((cell) => cell.number == number).length > 1 ||
        boardByRow(BoardFactory.getRowInGroup(index), groupIndex).where((cell) => cell.number == number).length > 1 ||
        boardByColumn(BoardFactory.getColumnInGroup(index), groupIndex).where((cell) => cell.number == number).length >
            1;
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
          final _isInThisRow = boardByRow(BoardFactory.getRowInGroup(index), groupIndex)
              .any((Cell cell) => listEquals([i, j], cell.coordinates));

          final _isInThisColumn = boardByColumn(BoardFactory.getColumnInGroup(index), groupIndex)
              .any((Cell cell) => listEquals([i, j], cell.coordinates));

          final _isInThisGroup =
              BoardFactory.boardByGroup(_board)[groupIndex].any((Cell cell) => listEquals([i, j], cell.coordinates));

          if (_isInThisRow || _isInThisColumn || _isInThisGroup) {
            _board[i][j].isHighlighted = true;
          }
        }
      }

      _clickedCell.isSelected = true;
      notifyListeners();
    }
  }

  @visibleForTesting
  void setBoard(List<List<Cell>> testBoard) {
    _board = testBoard;
  }
}
