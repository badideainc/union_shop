import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/product_page.dart';

void main() {
  group('Product Page Tests', () {
    Widget createTestWidget() {
      // Use the example product from assets: 'grad_bear'
      return const MaterialApp(home: ProductPage(productID: 'grad_bear'));
    }

    testWidgets('should display product page with basic elements', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check that product name and price from assets are present
      expect(find.text('Graduation Bear'), findsOneWidget);
      expect(find.text('£15.00'), findsOneWidget);
    });

    testWidgets('should display product option label', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Graduation Bear in assets has an options map with a 'Color' key
      expect(find.text('Color'), findsOneWidget);
    });

    testWidgets('should display header icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check that header icons are present
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check that footer contains the expected sections
      expect(find.text('Opening Hours'), findsOneWidget);
      expect(find.text('Latest Offers'), findsOneWidget);
    });
  });
}
