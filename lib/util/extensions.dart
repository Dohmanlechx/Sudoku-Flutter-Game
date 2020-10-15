extension IntListExtensions on List<int> {
  void refill() => this
    ..clear()
    ..addAll([1, 2, 3, 4, 5, 6, 7, 8, 9])
    ..shuffle();
}

extension BoardExtensions on List<List<int>> {
  void clearAllTiles() => this
    ..clear()
    ..addAll(List<List<int>>.generate(9, (_) => List.generate(9, (_) => 0)));
}
