import 'dart:async';

import 'package:rxdart/rxdart.dart';

class StopWatch {
  Stream<int> stopWatchStream({int startCounter}) {
    BehaviorSubject<int> _streamController;
    Timer _timer;
    var _timerInterval = const Duration(seconds: 1);
    var _counter = startCounter + 0;

    void _stopTimer() {
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
        _counter = 0;
        _streamController.close();
      }
    }

    void _tick(_) {
      _counter++;
      _streamController.add(_counter);
    }

    void _startTimer() {
      _timer = Timer.periodic(_timerInterval, _tick);
    }

    _streamController = BehaviorSubject<int>(
      onListen: _startTimer,
      onCancel: _stopTimer,
    );

    return _streamController.stream.asBroadcastStream();
  }
}
