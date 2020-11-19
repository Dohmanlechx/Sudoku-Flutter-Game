import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/app/strings.dart';
import 'package:sudoku_game/internal_storage.dart';
import 'package:sudoku_game/providers/game_provider.dart';
import 'package:sudoku_game/providers/theme_provider.dart';
import 'package:sudoku_game/styles/theme.dart';
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
      future: Future.wait([
        InternalStorage.retrieveRumbleEnabled(),
        InternalStorage.retrieveNightModeEnabled(),
      ]),
      builder: (BuildContext ctx, AsyncSnapshot<List<bool>> snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final _isRumbleEnabled = snapshot.data[0];
        final _isNightModeEnabled = snapshot.data[1];

        return Drawer(
          key: const Key('app_drawer'),
          child: Container(
            color: AppColors.drawer,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildTitleDivider(AppTranslations.newGame),
                  ...List.generate(Difficulty.values.length, (int index) {
                    return _buildListTile(
                      icon: Icons.add,
                      title: _difficultyTranslations[Difficulty.values[index]],
                      onTap: () => _triggerNewGame(context, Difficulty.values[index]),
                    );
                  }),
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
                    ),
                  ),
                  _buildListTile(
                    icon: Icons.brightness_4_outlined,
                    title: AppTranslations.darkTheme,
                    trailing: Switch.adaptive(
                      value: _isNightModeEnabled,
                      onChanged: (bool isToggled) async {
                        context.read<ThemeProvider>().toggleNightMode(isToggled);
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 64),
                  _buildVersionText(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _triggerNewGame(BuildContext context, Difficulty difficulty) async {
    Navigator.of(context).pop();
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
    final _color = AppColors.drawerTitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(title, style: AppTypography.dividerTitle.copyWith(color: _color)),
        ),
        Divider(thickness: 1, color: _color),
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
