import 'package:flutter/material.dart';

class NonScrollableGridView extends StatelessWidget {
  const NonScrollableGridView({
    this.children,
    this.crossAxisCount = 3,
  });

  final List<Widget> children;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      children: children,
    );
  }
}
