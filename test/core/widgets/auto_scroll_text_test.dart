import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dailypouch/core/widgets/auto_scroll_text.dart';

void main() {
  group('AutoScrollText Tests', () {
    testWidgets('renders text when text fits in container', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: AutoScrollText(
                text: 'Short Title',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Short Title'), findsOneWidget);
    });

    testWidgets('renders SingleChildScrollView for long text that exceeds constraint', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              child: AutoScrollText(
                text: 'Smart Unit Price & Value Calculator For Shopping',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.text('Smart Unit Price & Value Calculator For Shopping'), findsOneWidget);

      // Clean teardown
      await tester.pumpWidget(const SizedBox());
    });
  });
}
