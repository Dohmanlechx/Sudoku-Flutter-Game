import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/models/board.dart';

class InternalStorage {
  static const _keySession = 'prefs_key_session';

  static SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> storeSession(Board board) async {
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
}
