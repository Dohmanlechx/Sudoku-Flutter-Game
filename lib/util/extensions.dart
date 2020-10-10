extension IntListExtensions on List<int> {
  void refill() => this
    ..clear()
    ..addAll([1, 2, 3, 4, 5, 6, 7, 8, 9])
    ..shuffle();
}
