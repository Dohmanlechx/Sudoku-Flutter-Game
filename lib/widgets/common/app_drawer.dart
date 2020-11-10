import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/app/strings.dart';
import 'package:sudoku_game/providers/game_provider.dart';
import 'package:sudoku_game/styles/colors.dart';
import 'package:sudoku_game/styles/typography.dart';
import 'package:sudoku_game/util/device_util.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var versionText = "";

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
            _buildListTile(
              icon: Icons.add,
              title: AppTranslations.easy,
              onTap: () => _triggerNewGame(context, Difficulty.easy),
            ),
            _buildListTile(
              icon: Icons.add,
              title: AppTranslations.medium,
              onTap: () => _triggerNewGame(context, Difficulty.medium),
            ),
            _buildListTile(
              icon: Icons.add,
              title: AppTranslations.hard,
              onTap: () => _triggerNewGame(context, Difficulty.hard),
            ),
            const SizedBox(height: 100),
            _buildTitleDivider(AppTranslations.settings),
            _buildListTile(
                icon: Icons.app_settings_alt,
                title: AppTranslations.rumble,
                trailing: Switch.adaptive(
                  value: DeviceUtil.isRumbleEnabled,
                  onChanged: (bool isToggled) {
                    setState(() => DeviceUtil.isRumbleEnabled = isToggled);
                  },
                )),
            const SizedBox(height: 64),
            _buildVersionText(),
          ],
        ),
      ),
    );
  }

  void _triggerNewGame(BuildContext context, Difficulty difficulty) {
    context.read<GameProvider>().init(difficulty, isCalledByNewGame: true);
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
