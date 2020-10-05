import 'package:flutter/foundation.dart';

class BoardProvider with ChangeNotifier {
  final List<List<int>> list =
      List<List<int>>.generate(9, (int a) => List<int>.generate(9, (int b) => 1));
}
