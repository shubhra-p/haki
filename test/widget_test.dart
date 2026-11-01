// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haki/shared/widgets.dart';

void main() {
  group('Haki Design System Widgets', () {
    testWidgets('HakiCard renders child with elevation and responds to tap',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HakiCard(
              onTap: () => tapped = true,
              child: const Text('Flashcard Content'),
            ),
          ),
        ),
      );

      expect(find.text('Flashcard Content'), findsOneWidget);
      await tester.tap(find.text('Flashcard Content'));
      expect(tapped, isTrue);
    });

    testWidgets('HakiPillButton displays label, icon, and triggers onPressed',
        (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HakiPillButton(
              label: 'Study Now',
              icon: Icons.play_arrow,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Study Now'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);

      await tester.tap(find.text('Study Now'));
      expect(pressed, isTrue);
    });

    testWidgets('StreakPill formats streak count with flame icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StreakPill(streak: 14),
          ),
        ),
      );

      expect(find.text('14'), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    });

    testWidgets('CircularProgressBadge renders percentage text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircularProgressBadge(progress: 0.85),
          ),
        ),
      );

      expect(find.text('85%'), findsOneWidget);
    });
  });
}
