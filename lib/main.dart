import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/providers/board_provider.dart';
import 'package:sudoku_game/screens/game_screen.dart';

void main() => runApp(SudokuGameApp());

class SudokuGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BoardProvider()),
      ],
      child: const MaterialApp(
        home: GameScreen(),
      ),
    );
  }
}
