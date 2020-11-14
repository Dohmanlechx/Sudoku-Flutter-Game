import 'package:flutter/material.dart';
import 'package:sudoku_game/internal_storage.dart';
import 'package:vibration/vibration.dart';

class DeviceUtil {
  static double width(BuildContext context) => MediaQuery.of(context).size.width;

  static double height(BuildContext context) => MediaQuery.of(context).size.height;

  static bool isSmallDevice(BuildContext context) {
    final _physicalWidth = width(context) * MediaQuery.of(context).devicePixelRatio;
    return 720 >= _physicalWidth;
  }

  static Future<void> vibrate() async {
    if (await Vibration.hasVibrator() && await InternalStorage.retrieveRumbleEnabled()) {
      Vibration.vibrate(duration: 100);
    }
  }
}
