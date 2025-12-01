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
}
