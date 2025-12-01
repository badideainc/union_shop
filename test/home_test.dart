import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/models/product_model.dart';

void main() {
  group('Home Page Tests', () {
    testWidgets('should display home page with basic elements', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check that basic UI elements are present
      // Header should be present (use key to avoid brittle text match)
      expect(find.byKey(const Key('home-header')), findsOneWidget);
      expect(find.text('Placeholder Hero Title'), findsOneWidget);
      expect(find.text('PLACEHOLDER PRODUCTS SECTION'), findsOneWidget);
      expect(find.text('BROWSE PRODUCTS'), findsOneWidget);
      expect(find.text('VIEW ALL PRODUCTS'), findsOneWidget);
    });

    testWidgets('should display product cards', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check that product cards are displayed
      expect(find.text('Placeholder Product 1'), findsOneWidget);
      expect(find.text('Placeholder Product 2'), findsOneWidget);
      expect(find.text('Placeholder Product 3'), findsOneWidget);
      expect(find.text('Placeholder Product 4'), findsOneWidget);

      // Check prices are displayed
      expect(find.text('£10.00'), findsOneWidget);
      expect(find.text('£15.00'), findsOneWidget);
      expect(find.text('£20.00'), findsOneWidget);
      expect(find.text('£25.00'), findsOneWidget);
    });

    testWidgets('should display header icons', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check that header icons are present
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check that footer is present
      // Footer should be present (use key to avoid brittle text match)
      expect(find.byKey(const Key('home-footer')), findsOneWidget);
      expect(find.text('Placeholder Footer'), findsOneWidget);
      expect(
        find.text('Students should customise this footer section'),
        findsOneWidget,
      );
    });
  });

  group('Home Screen - Hero', () {
    testWidgets('shows hero title, description and CTA', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      expect(find.text('Placeholder Hero Title'), findsOneWidget);
      expect(find.text('This is placeholder text for the hero section.'),
          findsOneWidget);

      final btnFinder = find.widgetWithText(ElevatedButton, 'BROWSE PRODUCTS');
      expect(btnFinder, findsOneWidget);

      final ElevatedButton btn = tester.widget<ElevatedButton>(btnFinder);
      expect(btn.onPressed, isNotNull);
    });
  });

  group('Home Screen - Product Cards', () {
    testWidgets('shows product name and price for regular price',
        (WidgetTester tester) async {
      // Create a ProductModel snapshot with no salePrice
      final product = ProductModel.fromValues(
          id: 'test1', name: 'Test Product', price: 12.5, salePrice: -1);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProductCard(
            productID: 'test1',
            productFuture: Future.value(product),
          ),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('£12.50'), findsOneWidget);
    });

    testWidgets('shows sale price when salePrice >= 0',
        (WidgetTester tester) async {
      final product = ProductModel.fromValues(
          id: 'test2', name: 'Sale Product', price: 20.0, salePrice: 15.0);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProductCard(
            productID: 'test2',
            productFuture: Future.value(product),
          ),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Sale Product'), findsOneWidget);
      // Sale price displayed first
      expect(find.text('£15.00'), findsOneWidget);
      expect(find.text('£20.00'), findsOneWidget);
    });
  });
}
