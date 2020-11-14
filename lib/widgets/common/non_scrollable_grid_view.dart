import 'package:flutter/material.dart';

class NonScrollableGridView extends StatelessWidget {
  const NonScrollableGridView({
    this.children,
    this.crossAxisCount = 3,
    this.childAspectRatio,
  });

  final List<Widget> children;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: childAspectRatio ?? 1 / 1,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      children: children,
    );
  }
}
