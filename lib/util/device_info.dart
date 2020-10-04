import 'package:flutter/material.dart';

class DeviceInfo {
  static double width(BuildContext ctx) => MediaQuery.of(ctx).size.width;

  static double height(BuildContext ctx) => MediaQuery.of(ctx).size.height;
}
