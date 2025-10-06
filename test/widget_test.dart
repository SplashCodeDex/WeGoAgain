// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myapp/main.dart';

void main() {
  testWidgets('Renders the portfolio UI', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the main title is present.
    expect(find.text('Portfolio Building'), findsOneWidget);

    // Verify that the quote is present.
    expect(find.text('Act as a design mentor. Help me structure a beginner-friendly UX/UI design portfolio with 3 projects that showcase research, wireframes, and high-fidelity designs. Suggest how I can present each project clearly and compellingly.'), findsOneWidget);

    // Verify that the user's name is present.
    expect(find.text('Kingsley Orji'), findsOneWidget);
  });
}