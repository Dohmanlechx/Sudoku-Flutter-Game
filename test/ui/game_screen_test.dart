import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_game/main.dart';
import 'package:sudoku_game/widgets/game_screen/tile.dart';
import 'package:sudoku_game/widgets/game_screen/tile_group.dart';

void main() {
  testWidgets('Game Screen should create 9 TileGroups', (WidgetTester tester) async {
    await tester.pumpWidget(SudokuGameApp());
    expect(find.byType(TileGroup), findsNWidgets(9));
  });
  
  testWidgets('Game Screen Should create 81 Tiles', (WidgetTester tester) async {
    await tester.pumpWidget(SudokuGameApp());
    expect(find.byType(Tile), findsNWidgets(81));
  });
}
