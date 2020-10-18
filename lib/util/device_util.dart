import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class DeviceUtil {
  // TODO: Create SharedPrefs
  static bool isRumbleEnabled = false;

  static double width(BuildContext ctx) => MediaQuery.of(ctx).size.width;

  static double height(BuildContext ctx) => MediaQuery.of(ctx).size.height;

  static Future<void> vibrate() async {
    if (await Vibration.hasVibrator() && isRumbleEnabled) Vibration.vibrate(duration: 100);
  }
}
