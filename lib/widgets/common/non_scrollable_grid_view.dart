import 'package:flutter/material.dart';

class NonScrollableGridView extends StatelessWidget {
  const NonScrollableGridView({
    required this.children,
    this.crossAxisCount = 3,
    this.childAspectRatio = 1 / 1,
  });

  final List<Widget> children;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: childAspectRatio,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      children: children,
    );
  }
}
