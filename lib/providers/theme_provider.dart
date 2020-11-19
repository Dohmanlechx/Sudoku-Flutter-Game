import 'package:flutter/foundation.dart';
import 'package:sudoku_game/internal_storage.dart';

class ThemeProvider with ChangeNotifier {
  bool get isNightModeEnabled => InternalStorage.isNightModeEnabled;

  Future<void> toggleNightMode(bool value) async {
    await InternalStorage.storeNightModeEnabled(value);
    notifyListeners();
  }
}
