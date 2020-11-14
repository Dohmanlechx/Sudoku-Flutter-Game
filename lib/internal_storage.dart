import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/models/board.dart';
import 'package:sudoku_game/providers/game_provider.dart';
import 'package:sudoku_game/util/extensions.dart';

class InternalStorage {
  static const _keySession = 'prefs_key_session';
  static const _keyTimeTick = 'key_time_tick';
  static const _keyLives = 'key_lives';
  static const _keyDifficulty = 'key_difficulty';

  static SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> clearAllData() async {
    await _prefs.clear();
  }

  static Future<void> storeBoard(Board board) async {
    final Map<String, dynamic> _boardSerialized = board.toJson();
    final String _boardJson = jsonEncode(_boardSerialized);
    await _prefs.setString(_keySession, _boardJson);
  }

  static Future<Board> retrieveBoard() async {
    final String _boardJson = await _prefs.getString(_keySession);
    if (_boardJson == null) return null;

    final Map<String, dynamic> _boardDeserialized = jsonDecode(_boardJson);
    return Board.fromJson(_boardDeserialized);
  }

  static Future<void> storeTimeTick(int tick) async {
    await _prefs.setInt(_keyTimeTick, tick);
  }

  static Future<int> retrieveTimeTick() async {
    return await _prefs.getInt(_keyTimeTick) ?? 0;
  }

  static Future<void> storeLives(int lives) async {
    await _prefs.setInt(_keyLives, lives);
  }

  static Future<int> retrieveLives() async {
    return await _prefs.getInt(_keyLives) ?? 3;
  }

  static Future<void> storeDifficulty(Difficulty difficulty) async {
    await _prefs.setString(_keyDifficulty, difficulty.asString());
  }

  static Future<Difficulty> retrieveDifficulty() async {
    return await _prefs.getString(_keyDifficulty).toDifficultyEnum();
  }
}
