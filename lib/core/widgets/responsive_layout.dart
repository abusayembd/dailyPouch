import 'package:flutter/material.dart';

/// Helper widget to adapt layouts between phone screens (2-column grid)
/// and tablet/desktop screens (3-4 column grid).
class ResponsiveLayout extends StatelessWidget {
  final Widget Function(BuildContext context, int crossAxisCount) builder;

  const ResponsiveLayout({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth > 900) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 3;
        }
        return builder(context, crossAxisCount);
      },
    );
  }
}
