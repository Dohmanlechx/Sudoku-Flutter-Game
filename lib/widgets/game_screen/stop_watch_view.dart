import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/providers/game_provider.dart';
import 'package:sudoku_game/styles/typography.dart';
import 'package:sudoku_game/util/stop_watch.dart';

class StopWatchView extends StatefulWidget {
  const StopWatchView({this.isNewGame});

  final bool isNewGame;

  @override
  _StopWatchViewState createState() => _StopWatchViewState();
}

class _StopWatchViewState extends State<StopWatchView> {
  StopWatch _stopWatch;

  Stream<int> _timerStream;
  StreamSubscription<int> _timerSubscription;

  Stream<bool> _isNewGameStream;
  StreamSubscription<bool> _isNewGameSubscription;

  var _formattedTimerText = "";

  @override
  void dispose() {
    _isNewGameSubscription.cancel();
    _timerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isNewGameStream = context.watch<GameProvider>().isNewGameStream;

    if (_isNewGameSubscription == null) {
      _isNewGameSubscription = _isNewGameStream.listen((bool isNewGame) {
        if (isNewGame) _resetTimerAndSetupListener();
      });
    }

    return Center(child: Text(_formattedTimerText, style: AppTypography.body));
  }

  void _resetTimerAndSetupListener() {
    setState(() => _formattedTimerText = "00:00");

    if (_timerSubscription != null) {
      _timerSubscription.cancel();
    }

    _stopWatch = StopWatch();
    _timerStream = _stopWatch.stopWatchStream();
    _timerSubscription = _timerStream.listen((int newTick) {
      setState(() => _formattedTimerText = _getFormattedTimerText(newTick));
    });
  }

  String _getFormattedTimerText(int newTick) =>
      '${((newTick / 60) % 60).floor().toString().padLeft(2, '0')}:${(newTick % 60).floor().toString().padLeft(2, '0')}';
}
