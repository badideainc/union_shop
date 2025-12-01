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

      // Open the first DropdownButton (category)
      final dropdownFinder = find.byType(DropdownButton).first;
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      // Select the 'Clothing' category from the menu
      await tester.tap(find.text('Clothing').last);
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

      // Open the sort DropdownButton (second)
      final sortDropdown = find.byType(DropdownButton).last;
      await tester.tap(sortDropdown);
      await tester.pumpAndSettle();

      // Select Price Low-High
      await tester.tap(find.text('Price Low-High').last);
      await tester.pumpAndSettle();

      // Effective prices: p2=2 (sale), p3=3, p1=5 => expected order p2, p3, p1
      final ids = emitted!.map((p) => p.id).toList();
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

      await tester.pump();
      await tester.pumpAndSettle();

      final sortDropdown = find.byType(DropdownButton).last;
      await tester.tap(sortDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alphabetical A-Z').last);
      await tester.pumpAndSettle();

      expect(emitted!.map((p) => p.name).toList(), ['Apple', 'Banana']);
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

      // Open category dropdown and select 'SALE!' which none of the products have
      final dropdownFinder = find.byType(DropdownButton).first;
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      // Category label for ProductCategory.sale is 'SALE!' (see categoryTitle)
      await tester.tap(find.text('SALE!').last);
      await tester.pumpAndSettle();

      expect(emitted, isNotNull);
      expect(emitted!.isEmpty, isTrue);
    });
  });
}
