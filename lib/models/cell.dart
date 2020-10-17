import 'package:sudoku_game/util/extensions.dart';

class Cell {
  Cell({
    this.number = 0,
    this.solutionNumber,
    this.isClickable = true,
    this.coordinates,
    this.availableNumbers,
  }) {
    availableNumbers = [];
    refillAvailableNumbers();
  }

  int number;
  int solutionNumber;
  bool isClickable;
  List<int> coordinates;
  List<int> availableNumbers;

  bool get isNotFilled => number == 0;
}
