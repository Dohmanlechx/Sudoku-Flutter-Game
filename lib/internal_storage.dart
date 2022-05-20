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
  static const _keySundayEnabled = 'key_sunday_enabled';
  static const _keyRumbleEnabled = 'key_rumble_enabled';
  static const _keyNightModeEnabled = 'key_night_mode_enabled';

  static SharedPreferences? _prefs;
  static bool isNightModeEnabled = false;
  static bool isSundayModeEnabled = false;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    isNightModeEnabled = await retrieveNightModeEnabled();
    isSundayModeEnabled = await retrieveSundayModeEnabled();
  }

  static Future<void> clearGameSessionData() async {
    await _prefs?.remove(_keySession);
    await _prefs?.remove(_keyTimeTick);
    await _prefs?.remove(_keyLives);
    await _prefs?.remove(_keyDifficulty);
  }

  static Future<void> storeBoard(Board board) async {
    final _boardSerialized = board.toJson();
    final _boardJson = jsonEncode(_boardSerialized);
    await _prefs?.setString(_keySession, _boardJson);
  }

  static Future<Board?> retrieveBoard() async {
    final _boardJson = _prefs?.getString(_keySession);
    if (_boardJson == null) return null;

    final Map<String, dynamic> _boardDeserialized = jsonDecode(_boardJson);
    return Board.fromJson(_boardDeserialized);
  }

  static Future<void> storeTimeTick(int tick) async {
    await _prefs?.setInt(_keyTimeTick, tick);
  }

  static Future<int> retrieveTimeTick() async {
    return _prefs?.getInt(_keyTimeTick) ?? 0;
  }

  static Future<void> storeLives(int lives) async {
    await _prefs?.setInt(_keyLives, lives);
  }

  static Future<int> retrieveLives() async {
    return _prefs?.getInt(_keyLives) ?? 3;
  }

  static Future<void> storeDifficulty(Difficulty difficulty) async {
    if (difficulty.asString() == null) return;
    await _prefs?.setString(_keyDifficulty, difficulty.asString()!);
  }

  static Future<Difficulty?> retrieveDifficulty() async {
    return _prefs?.getString(_keyDifficulty)?.toDifficultyEnum();
  }

  static Future<void> storeSundayModeEnabled(bool value) async {
    isSundayModeEnabled = value;
    await _prefs?.remove(_keyTimeTick);
    await _prefs?.setBool(_keySundayEnabled, value);
  }

  static Future<bool> retrieveSundayModeEnabled() async {
    return _prefs?.getBool(_keySundayEnabled) ?? false;
  }

  static Future<void> storeRumbleEnabled(bool value) async {
    await _prefs?.setBool(_keyRumbleEnabled, value);
  }

  static Future<bool> retrieveRumbleEnabled() async {
    return _prefs?.getBool(_keyRumbleEnabled) ?? true;
  }

  static Future<void> storeNightModeEnabled(bool value) async {
    isNightModeEnabled = value;
    await _prefs?.setBool(_keyNightModeEnabled, value);
  }

  static Future<bool> retrieveNightModeEnabled() async {
    return _prefs?.getBool(_keyNightModeEnabled) ?? false;
  }
}
