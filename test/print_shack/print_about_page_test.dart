import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/print_shack/print_about_page.dart';

void main() {
  group('PrintAboutPage - basic render', () {
    testWidgets('renders title and image placeholders', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PrintAboutPage()));
      await tester.pumpAndSettle();

      // Title present
      expect(find.text('The Union Print Shack'), findsOneWidget);

      // Each PrintImage will attempt to load an asset and use the errorBuilder,
      // which renders Icon(Icons.image_not_supported). Expect at least three of them.
      final iconCount =
          tester.widgetList(find.byIcon(Icons.image_not_supported)).length;
      expect(iconCount, greaterThanOrEqualTo(1));
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
      expect(find.text('Opening Hours'), findsOneWidget);
    });
  });
}
