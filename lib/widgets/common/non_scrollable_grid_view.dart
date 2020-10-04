import 'package:flutter/material.dart';

class NonScrollableGridView extends StatelessWidget {
  const NonScrollableGridView({this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      children: children,
    );
  }
}
