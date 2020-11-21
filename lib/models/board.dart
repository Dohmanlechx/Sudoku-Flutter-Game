import 'package:json_annotation/json_annotation.dart';
import 'package:sudoku_game/models/cell.dart';

part 'board.g.dart';

@JsonSerializable()
class Board {
  Board() {
    cells = List();
    hasBeenStartedPlaying = false;
    clearAllTiles();
  }

  List<List<Cell>> cells;
  bool hasBeenStartedPlaying;

  void clearAllTiles() {
    this.cells
      ..clear()
      ..addAll(
        List<List<Cell>>.generate(9, (_) => List.generate(9, (_) => Cell())),
      );
  }

  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);

  Map<String, dynamic> toJson() => _$BoardToJson(this);
}
