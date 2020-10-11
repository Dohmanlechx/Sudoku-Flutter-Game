import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/app/strings.dart';
import 'package:sudoku_game/providers/board_provider.dart';
import 'package:sudoku_game/styles/colors.dart';
import 'package:sudoku_game/styles/typography.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  // TODO: Create SettingsProvider
  bool isRumbleEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text(AppTranslations.mainMenu),
            leading: const Icon(Icons.menu),
            backgroundColor: AppColors.accent,
          ),
          _buildTitleDivider(AppTranslations.mainMenu),
          _buildListTile(
            icon: Icons.add,
            title: AppTranslations.newGame,
            onTap: () => _triggerNewGame(context),
          ),
          const SizedBox(height: 100),
          _buildTitleDivider(AppTranslations.settings),
          _buildListTile(
              icon: Icons.app_settings_alt,
              title: AppTranslations.rumble,
              trailing: Switch.adaptive(
                value: isRumbleEnabled,
                onChanged: (bool isToggled) {
                  setState(() => isRumbleEnabled = isToggled);
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _triggerNewGame(BuildContext context) {
    context.read<BoardProvider>().buildBoard();
    Navigator.of(context).pop();
  }

  Widget _buildListTile({
    IconData icon,
    String title,
    Function onTap,
    Widget trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.black),
      title: Text(title, style: AppTypography.appDrawerEntry),
      onTap: onTap,
      trailing: trailing ?? const SizedBox(),
    );
  }

  Widget _buildTitleDivider(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
          child: Text(title, style: AppTypography.dividerTitle),
        ),
        const Divider(thickness: 1),
      ],
    );
  }
}
