import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/providers/game_provider.dart';
import 'package:sudoku_game/screens/game_screen.dart';
import 'package:sudoku_game/styles/theme.dart';

void main() => runApp(SudokuGameApp());

class SudokuGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: MaterialApp(
        key: const Key('sudoku_game'),
        home: const GameScreen(),
        theme: appTheme,
      ),
    );
  }
}
