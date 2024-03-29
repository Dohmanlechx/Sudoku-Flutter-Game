import 'package:json_annotation/json_annotation.dart';
import 'package:sudoku_game/util/extensions.dart';

part 'cell.g.dart';

@JsonSerializable()
class Cell {
  Cell({
    this.number = 0,
    this.solutionNumber,
    this.isClickable = true,
    this.isSelected = false,
    this.isHighlighted = false,
    this.coordinates,
    this.availableNumbers,
    this.maybeNumbers,
  }) {
    _initCell();
  }

  int? number;
  int? solutionNumber;
  bool? isClickable;
  bool? isSelected;
  bool? isHighlighted;
  List<int>? coordinates;
  List<int>? availableNumbers;
  List<int>? maybeNumbers;

  bool get isNotFilled => (number ?? 0) <= 0;
  bool get isFilled => (number ?? 0) > 0;

  int get i => coordinates![0];

  int get j => coordinates![1];

  void _initCell() {
    coordinates ??= [];
    availableNumbers ??= [];
    maybeNumbers ??= [];
    refillAvailableNumbers();
  }

  factory Cell.fromJson(Map<String, dynamic> json) => _$CellFromJson(json);

  Map<String, dynamic> toJson() => _$CellToJson(this);
}
