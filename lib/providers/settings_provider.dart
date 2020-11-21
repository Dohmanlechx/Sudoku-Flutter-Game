import 'package:flutter/foundation.dart';
import 'package:sudoku_game/internal_storage.dart';

class SettingsProvider with ChangeNotifier {
  bool get isNightModeEnabled => InternalStorage.isNightModeEnabled;

  Future<void> toggleNightMode(bool value) async {
    await InternalStorage.storeNightModeEnabled(value);
    notifyListeners();
  }

  bool get isSundayModeEnabled => InternalStorage.isSundayModeEnabled;

  Future<void> toggleSundayMode(bool value) async {
    await InternalStorage.storeSundayModeEnabled(value);
    notifyListeners();
  }
}
