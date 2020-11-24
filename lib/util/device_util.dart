import 'package:flutter/material.dart';
import 'package:sudoku_game/internal_storage.dart';
import 'package:vibration/vibration.dart';

class DeviceUtil {
  static double width(BuildContext context) => MediaQuery.of(context).size.width;

  static double height(BuildContext context) => MediaQuery.of(context).size.height;

  static bool isSmallDevice(BuildContext context, {int limit = 1920}) {
    final _physicalHeight = height(context) * MediaQuery.of(context).devicePixelRatio;
    return limit >= _physicalHeight;
  }

  static Future<void> vibrate({int ms}) async {
    if (await Vibration.hasVibrator() && await InternalStorage.retrieveRumbleEnabled()) {
      Vibration.vibrate(duration: ms);
    }
  }
}
