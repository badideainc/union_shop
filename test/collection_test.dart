import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/collection_page.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/models/category.dart';

void main() {
  group('FilterDropdown - initial emission', () {
    testWidgets('emits initial full product list via onChanged',
        (tester) async {
      final products = [
        ProductModel.fromValues(
            id: 'p1',
            name: 'Apple',
            category: [ProductCategory.clothing],
            price: 1.0),
        ProductModel.fromValues(
            id: 'p2',
            name: 'Banana',
            category: [ProductCategory.merchandise],
            price: 2.0),
      ];

      List<ProductModel>? emitted;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FilterDropdown(
            products: products,
            onChanged: (list) {
              emitted = list;
            },
          ),
        ),
      ));

      // Allow post-frame callbacks to run
      await tester.pump();
      await tester.pumpAndSettle();

      expect(emitted, isNotNull);
      expect(emitted!.length, products.length);
      // Ensure emitted items are the same ids (order preserved by default)
      expect(emitted!.map((p) => p.id).toList(),
          products.map((p) => p.id).toList());
    });
  });
  group('FilterDropdown - filtering', () {
    testWidgets('selecting a category filters products accordingly',
        (tester) async {
      final products = [
        ProductModel.fromValues(
            id: 'p1',
            name: 'Apple',
            category: [ProductCategory.clothing],
            price: 1.0),
        ProductModel.fromValues(
            id: 'p2',
            name: 'Banana',
            category: [ProductCategory.merchandise],
            price: 2.0),
      ];

      List<ProductModel>? emitted;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FilterDropdown(
            products: products,
            onChanged: (list) {
              emitted = list;
            },
          ),
        ),
      ));

      // Allow initial post-frame emission
      await tester.pump();
      await tester.pumpAndSettle();

      expect(emitted, isNotNull);
      expect(emitted!.length, 2);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FilterDropdown(
            key: const ValueKey('fd-clothing'),
            products: products,
            initialCategory: ProductCategory.clothing,
            onChanged: (list) {
              emitted = list;
            },
          ),
        ),
      ));

      await tester.pump();
      await tester.pumpAndSettle();

      // Emitted should now contain only the clothing product
      expect(emitted, isNotNull);
      expect(emitted!.length, 1);
      expect(emitted!.first.id, 'p1');
    });
  });

  group('FilterDropdown - sorting', () {
    testWidgets('price sorting orders by effective price (salePrice when >0)',
        (tester) async {
      final products = [
        ProductModel.fromValues(
            id: 'p1',
            name: 'Expensive',
            category: [ProductCategory.clothing],
            price: 5.0),
        ProductModel.fromValues(
            id: 'p2',
            name: 'CheapOnSale',
            category: [ProductCategory.clothing],
            price: 4.0,
            salePrice: 2.0),
        ProductModel.fromValues(
            id: 'p3',
            name: 'Regular',
            category: [ProductCategory.clothing],
            price: 3.0),
      ];

      List<ProductModel>? emitted;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FilterDropdown(
            products: products,
            onChanged: (list) {
              emitted = list;
            },
          ),
        ),
      ));

      // Allow initial post-frame emission
      await tester.pump();
      await tester.pumpAndSettle();

      expect(emitted, isNotNull);
      expect(emitted!.length, 3);

      // Re-render FilterDropdown with initialSort to deterministically trigger sorting
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FilterDropdown(
            products: products,
            initialSort: SortOption.priceLowHigh,
            onChanged: (list) {
              emitted = list;
            },
          ),
        ),
      ));

      await tester.pump();
      await tester.pumpAndSettle();

      // Directly test the sorting helper to avoid overlay interactions.
      final sorted =
          FilterDropdown.sortProducts(products, SortOption.priceLowHigh);
      final ids = sorted.map((p) => p.id).toList();
      expect(ids, ['p2', 'p3', 'p1']);
    });

    testWidgets('alphabetical A-Z sorts by name', (tester) async {
      final products = [
        ProductModel.fromValues(
            id: 'p1',
            name: 'Banana',
            category: [ProductCategory.clothing],
            price: 1.0),
        ProductModel.fromValues(
            id: 'p2',
            name: 'Apple',
            category: [ProductCategory.clothing],
            price: 2.0),
      ];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FilterDropdown(
            products: products,
            onChanged: (list) {},
          ),
        ),
      ));

      await tester.pump();
      await tester.pumpAndSettle();

      // Re-render FilterDropdown with initialSort alphabetical asc
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FilterDropdown(
            products: products,
            initialSort: SortOption.alphabeticalAsc,
            onChanged: (list) {},
          ),
        ),
      ));

      await tester.pump();
      await tester.pumpAndSettle();

      final sortedNames =
          FilterDropdown.sortProducts(products, SortOption.alphabeticalAsc);
      expect(sortedNames.map((p) => p.name).toList(), ['Apple', 'Banana']);
    });
  });

  group('FilterDropdown - empty results', () {
    testWidgets('emits empty list when no products match selected category',
        (tester) async {
      final products = [
        ProductModel.fromValues(
            id: 'p1',
            name: 'Apple',
            category: [ProductCategory.clothing],
            price: 1.0),
        ProductModel.fromValues(
            id: 'p2',
            name: 'Banana',
            category: [ProductCategory.merchandise],
            price: 2.0),
      ];

      List<ProductModel>? emitted;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FilterDropdown(
            products: products,
            onChanged: (list) {
              emitted = list;
            },
          ),
        ),
      ));

      // Allow initial emission
      await tester.pump();
      await tester.pumpAndSettle();

      // Instead of interacting with dropdown overlays, re-render the widget
      // with an initialCategory of `sale` to deterministically trigger the
      // empty result emission.
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FilterDropdown(
            key: const ValueKey('fd-sale'),
            products: products,
            initialCategory: ProductCategory.sale,
            onChanged: (list) {
              emitted = list;
            },
          ),
        ),
      ));

      await tester.pump();
      await tester.pumpAndSettle();

      expect(emitted, isNotNull);
      expect(emitted!.isEmpty, isTrue);
    });
  });

  group('CollectionPage - FutureBuilder loading state', () {
    testWidgets('shows loading indicator while products load', (tester) async {
      final completer = Completer<List<Map<String, dynamic>>>();

      await tester.pumpWidget(MaterialApp(
        home: CollectionPage(
          category: ProductCategory.clothing,
          productLoader: () => completer.future,
        ),
      ));

      // First frame: FutureBuilder should be waiting and show CircularProgressIndicator
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the future and ensure UI updates
      completer.complete(<Map<String, dynamic>>[]);
      await tester.pumpAndSettle();

      // After completion, no loading indicator
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
