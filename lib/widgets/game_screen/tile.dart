import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  const Tile();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
      ),
    );
  }
}
