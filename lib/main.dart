import 'package:flutter/material.dart';
import 'package:sudoku_game/screens/game_screen.dart';

void main() => runApp(SudokuGameApp());

class SudokuGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const GameScreen(),
    );
  }
}
