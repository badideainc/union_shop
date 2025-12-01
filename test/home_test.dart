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
      expect(find.text('Essential Range - 20% off'), findsOneWidget);
      expect(find.text('PRODUCTS SECTION'), findsOneWidget);
      expect(find.text('BROWSE PRODUCTS'), findsOneWidget);
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
      expect(find.text('Opening Hours'), findsOneWidget);
      expect(find.text('Help and Information'), findsOneWidget);
      expect(find.text('Latest Offers'), findsOneWidget);
      expect(find.text('Subscribe'), findsOneWidget);
    });
  });

  group('Home Screen - Hero', () {
    testWidgets('shows hero title, description and CTA', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      expect(find.text('Essential Range - 20% off'), findsOneWidget);
      expect(find.text('Come get them while stocks last!'), findsOneWidget);

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

  group('Home Screen - Header Icons', () {
    testWidgets('header icons present and enabled', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      final searchFinder = find.byIcon(Icons.search);
      final accountFinder = find.byIcon(Icons.person_outline);
      final cartFinder = find.byIcon(Icons.shopping_bag_outlined);
      final menuFinder = find.byIcon(Icons.menu);

      expect(searchFinder, findsOneWidget);
      expect(accountFinder, findsOneWidget);
      expect(cartFinder, findsOneWidget);
      expect(menuFinder, findsOneWidget);

      final IconButton searchBtn = tester.widget(
          find.ancestor(of: searchFinder, matching: find.byType(IconButton)));
      final IconButton accountBtn = tester.widget(
          find.ancestor(of: accountFinder, matching: find.byType(IconButton)));
      final IconButton cartBtn = tester.widget(
          find.ancestor(of: cartFinder, matching: find.byType(IconButton)));
      final IconButton menuBtn = tester.widget(
          find.ancestor(of: menuFinder, matching: find.byType(IconButton)));

      expect(searchBtn.onPressed, isNotNull);
      expect(accountBtn.onPressed, isNotNull);
      expect(cartBtn.onPressed, isNotNull);
      expect(menuBtn.onPressed, isNotNull);
    });
  });
}
