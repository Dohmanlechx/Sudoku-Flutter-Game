import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/internal_storage.dart';
import 'package:sudoku_game/providers/game_provider.dart';
import 'package:sudoku_game/styles/typography.dart';
import 'package:sudoku_game/util/stop_watch.dart';

class StopWatchView extends StatefulWidget {
  const StopWatchView();

  @override
  _StopWatchViewState createState() => _StopWatchViewState();
}

class _StopWatchViewState extends State<StopWatchView> with WidgetsBindingObserver {
  StopWatch? _stopWatch;

  Stream<int>? _timerStream;
  StreamSubscription<int>? _timerSubscription;

  Stream<bool>? _isNewGameStream;
  StreamSubscription<bool>? _isNewGameSubscription;

  Stream<bool>? _isRoundDoneStream;
  StreamSubscription<bool>? _isRoundDoneSubscription;

  var _formattedTimerText = '';

  int _ongoingTick = 0;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      await InternalStorage.storeTimeTick(_ongoingTick);
      _disposeTimer();
    } else if (state == AppLifecycleState.resumed) {
      await _restoreTimerAndSetupListener();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _disposeTimer();
    _disposeStreamsAndSubscriptions();
    _isNewGameSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isNewGameStream = context.watch<GameProvider>().isNewGameStream;
    _isRoundDoneStream = context.watch<GameProvider>().isRoundDoneStream;

    _isNewGameSubscription ??= _isNewGameStream?.listen(
      (bool isNewGame) {
        if (isNewGame) {
          _disposeTimer();
          _restoreTimerAndSetupListener();
        }
      },
    );

    _isRoundDoneSubscription ??= _isRoundDoneStream?.listen(
      (bool isRoundDone) {
        if (isRoundDone) _disposeTimer();
      },
    );

    return Center(child: Text(_formattedTimerText, style: AppTypography.timer));
  }

  void _disposeTimer() {
    _stopWatch = null;
    _timerStream = null;
    _timerSubscription?.cancel();
    _timerSubscription = null;
  }

  void _disposeStreamsAndSubscriptions() {
    _isNewGameStream = null;
    _isNewGameSubscription?.cancel();
    _isNewGameSubscription = null;

    _isRoundDoneStream = null;
    _isRoundDoneSubscription?.cancel();
    _isRoundDoneSubscription = null;
  }

  Future<void> _restoreTimerAndSetupListener() async {
    _ongoingTick = 0;

    final _savedTick = await InternalStorage.retrieveTimeTick();
    _updateTimerText(_savedTick + _ongoingTick);

    if (_timerSubscription != null) {
      await _timerSubscription?.cancel();
    }

    _stopWatch = StopWatch();

    _timerStream = _stopWatch?.stopWatchStream(startCounter: _savedTick + _ongoingTick);

    _timerSubscription = _timerStream?.listen((int newTick) {
      _ongoingTick = newTick;
      _updateTimerText(_ongoingTick);
    });
  }

  void _updateTimerText(int tick) {
    setState(() {
      _formattedTimerText = _getFormattedTimerText(tick);
    });
  }

  String _getFormattedTimerText(int newTick) {
    final h = (newTick >= 3600) ? '${(newTick / 3600).floor().toString()}:' : '';
    final m = '${((newTick / 60) % 60).floor().toString().padLeft(2, '0')}:';
    final s = (newTick % 60).floor().toString().padLeft(2, '0');

    return '$h$m$s';
  }
}
