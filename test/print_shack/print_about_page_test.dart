import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/print_shack/print_about_page.dart';

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
}
