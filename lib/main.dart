import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/internal_storage.dart';
import 'package:sudoku_game/providers/game_provider.dart';
import 'package:sudoku_game/providers/settings_provider.dart';
import 'package:sudoku_game/screens/game_screen.dart';
import 'package:sudoku_game/styles/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InternalStorage.init();
  runApp(const SudokuGameApp());
}

class SudokuGameApp extends StatelessWidget {
  const SudokuGameApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      builder: (BuildContext context, _) {
        return MaterialApp(
          key: const Key('sudoku_game'),
          home: const GameScreen(),
          theme: context.watch<SettingsProvider>().isNightModeEnabled ? appThemeDark : appTheme,
        );
      },
    );
  }
}
