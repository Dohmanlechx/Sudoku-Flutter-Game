import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/app/strings.dart';
import 'package:sudoku_game/providers/board_provider.dart';
import 'package:sudoku_game/styles/colors.dart';
import 'package:sudoku_game/styles/typography.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text(AppTranslations.settings),
            leading: const Icon(Icons.settings),
            backgroundColor: AppColors.accent,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.add, color: AppColors.black),
            title: const Text(
              AppTranslations.newGame,
              style: AppTypography.appDrawerEntry,
            ),
            onTap: () {
              context.read<BoardProvider>().buildBoard();
              Navigator.of(context).pop();
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
