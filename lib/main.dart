import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/providers/board_provider.dart';
import 'package:sudoku_game/screens/game_screen.dart';
import 'package:sudoku_game/styles/theme.dart';

void main() => runApp(SudokuGameApp());

class SudokuGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BoardProvider()),
      ],
      child: MaterialApp(
        home: const GameScreen(),
        theme: appTheme,
      ),
    );
  }
}
