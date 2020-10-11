import 'package:flutter_driver/driver_extension.dart';
import 'package:sudoku_game/main.dart' as app;

/**
 * To run, write this in the terminal:
 * flutter drive --target=test_driver/app.dart
 */

void main() {
  enableFlutterDriverExtension();
  app.main();
}
