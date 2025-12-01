import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/print_shack/print_about_page.dart';

import 'package:union_shop/main.dart';

void main() {
  group('PrintAboutPage - basic render', () {
    testWidgets('renders title and three image placeholders', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PrintAboutPage()));
      await tester.pumpAndSettle();

      // Title present
      expect(find.text('The Union Print Shack'), findsOneWidget);

      // Each PrintImage will attempt to load an asset and use the errorBuilder,
      // which renders Icon(Icons.image_not_supported). Expect three of them.
      expect(find.byIcon(Icons.image_not_supported), findsNWidgets(3));
    });
  });

  group('PrintImage - errorBuilder fallback', () {
    testWidgets('shows placeholder icon when asset missing', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: PrintImage(imageUrl: 'assets/images/nonexistent.png'),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    });
  });

  group('PrintAboutPage - header and footer presence', () {
    testWidgets('contains Header and Footer widgets', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PrintAboutPage()));
      await tester.pumpAndSettle();

      // Try locating Header and Footer types. If these are private/internal
      // widgets they should still appear as runtime types in the widget tree.
      expect(find.byType(Header), findsOneWidget);
      expect(find.byType(Footer), findsOneWidget);
    });
  });
}
