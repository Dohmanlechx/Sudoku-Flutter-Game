import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/app/strings.dart';
import 'package:sudoku_game/internal_storage.dart';
import 'package:sudoku_game/providers/game_provider.dart';
import 'package:sudoku_game/providers/settings_provider.dart';
import 'package:sudoku_game/styles/theme.dart';
import 'package:sudoku_game/styles/typography.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer();

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var versionText = '';

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
        versionText = 'v${pkgInfo.version}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        InternalStorage.retrieveRumbleEnabled(),
        InternalStorage.retrieveNightModeEnabled(),
        InternalStorage.retrieveSundayModeEnabled(),
      ]),
      builder: (BuildContext ctx, AsyncSnapshot<List<bool>> snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final _isRumbleEnabled = snapshot.data?[0] ?? false;
        final _isNightModeEnabled = snapshot.data?[1] ?? false;
        final _isSundayEnabled = snapshot.data?[2] ?? false;

        return Drawer(
          key: const Key('app_drawer'),
          child: Container(
            color: AppColors.drawer,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildTitleDivider(AppTranslations.newGame),
                  ..._buildDifficulties(),
                  _buildTitleDivider(AppTranslations.modes),
                  _buildSundaySudokuSetting(_isSundayEnabled),
                  _buildTitleDivider(AppTranslations.settings),
                  _buildRumbleSetting(_isRumbleEnabled),
                  _buildNightModeSetting(_isNightModeEnabled),
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

  Future<void> _triggerNewGame(
      BuildContext context, Difficulty difficulty) async {
    Navigator.of(context).pop();
    context.read<GameProvider>().init(difficulty, isCalledByNewGame: true);
  }

  List<Widget> _buildDifficulties() {
    return List.generate(Difficulty.values.length, (int index) {
      return _buildListTile(
        icon: Icons.add,
        title: _difficultyTranslations[Difficulty.values[index]] ?? '',
        onTap: () => _triggerNewGame(context, Difficulty.values[index]),
      );
    });
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Function? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.black),
      title: Text(
        title,
        style: AppTypography.body.copyWith(color: AppColors.black),
      ),
      onTap: () => onTap != null ? onTap() : () {},
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
          child: Text(title,
              style: AppTypography.dividerTitle.copyWith(color: _color)),
        ),
        Divider(thickness: 1, color: _color),
      ],
    );
  }

  Widget _buildSundaySudokuSetting(bool isSundaySudokuEnabled) {
    return _buildListTile(
      icon: Icons.all_inclusive,
      title: AppTranslations.sundaySudoku,
      trailing: Switch.adaptive(
        value: isSundaySudokuEnabled,
        onChanged: (bool isToggled) async {
          if (context.read<GameProvider>().hasBeenStartedPlaying) {
            if (isToggled) {
              var _userApproved = false;

              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text(
                      AppTranslations.enableSundayDialogText,
                      style: AppTypography.body,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _userApproved = true;
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          AppTranslations.yes.toUpperCase(),
                          style:
                              AppTypography.body.copyWith(color: AppColors.red),
                        ),
                      )
                    ],
                  );
                },
              );

              if (!_userApproved) return;
            } else {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertDialog(
                    content: Text(
                      AppTranslations.disableSundayDialogText,
                      style: AppTypography.body,
                    ),
                  );
                },
              );

              return;
            }
          }

          await context.read<SettingsProvider>().toggleSundayMode(isToggled);
          setState(() {});
        },
      ),
    );
  }

  Widget _buildRumbleSetting(bool isRumbleEnabled) {
    return _buildListTile(
      icon: Icons.app_settings_alt,
      title: AppTranslations.rumble,
      trailing: Switch.adaptive(
        value: isRumbleEnabled,
        onChanged: (bool isToggled) async {
          await InternalStorage.storeRumbleEnabled(isToggled);
          setState(() {});
        },
      ),
    );
  }

  Widget _buildNightModeSetting(bool isNightModeEnabled) {
    return _buildListTile(
      icon: Icons.brightness_4_outlined,
      title: AppTranslations.darkTheme,
      trailing: Switch.adaptive(
        value: isNightModeEnabled,
        onChanged: (bool isToggled) async {
          await context.read<SettingsProvider>().toggleNightMode(isToggled);
          setState(() {});
        },
      ),
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
