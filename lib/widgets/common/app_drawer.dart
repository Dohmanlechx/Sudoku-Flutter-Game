import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/app/strings.dart';
import 'package:sudoku_game/internal_storage.dart';
import 'package:sudoku_game/providers/game_provider.dart';
import 'package:sudoku_game/styles/colors.dart';
import 'package:sudoku_game/styles/typography.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer();

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var versionText = "";

  final _difficultyTranslations = {
    Difficulty.easy: AppTranslations.easy,
    Difficulty.medium: AppTranslations.medium,
    Difficulty.hard: AppTranslations.hard,
    Difficulty.extreme: AppTranslations.extreme,
  };

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo pkgInfo) {
      setState(() {
        versionText = "v${pkgInfo.version}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: InternalStorage.retrieveRumbleEnabled(),
      builder: (BuildContext ctx, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final _isRumbleEnabled = snapshot.data;

        return Drawer(
          key: const Key('app_drawer'),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                AppBar(
                  title: const Text(
                    AppTranslations.mainMenu,
                    key: ValueKey('drawer_headline_text'),
                  ),
                  leading: const Icon(Icons.menu),
                  backgroundColor: AppColors.accent,
                ),
                _buildTitleDivider(AppTranslations.newGame),
                ...List.generate(Difficulty.values.length - 1, (int index) {
                  return _buildListTile(
                    icon: Icons.add,
                    title: _difficultyTranslations[Difficulty.values[index]],
                    onTap: () => _triggerNewGame(context, Difficulty.values[index]),
                  );
                }),
                const SizedBox(height: 100),
                _buildTitleDivider(AppTranslations.settings),
                _buildListTile(
                    icon: Icons.app_settings_alt,
                    title: AppTranslations.rumble,
                    trailing: Switch.adaptive(
                      value: _isRumbleEnabled,
                      onChanged: (bool isToggled) async {
                        await InternalStorage.storeRumbleEnabled(isToggled);
                        setState(() {});
                      },
                    )),
                const SizedBox(height: 64),
                _buildVersionText(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _triggerNewGame(BuildContext context, Difficulty difficulty) async {
    final _isExtreme = (difficulty == Difficulty.extreme); // Because solving Extreme boards using BoardSolver might take a while

    Navigator.of(context).pop();

    if (_isExtreme) {
      context.read<GameProvider>().startLoader();
      await Future.delayed(const Duration(milliseconds: 300));
    }

    context.read<GameProvider>().init(difficulty, isCalledByNewGame: true);
  }

  Widget _buildListTile({
    IconData icon,
    String title,
    Function onTap,
    Widget trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.black),
      title: Text(title, style: AppTypography.body),
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

  Widget _buildVersionText() {
    return Container(
      padding: const EdgeInsets.only(right: 16),
      width: double.infinity,
      child: Text(
        versionText,
        textAlign: TextAlign.end,
        style: AppTypography.timer.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.black.withOpacity(0.5),
        ),
      ),
    );
  }
}
