import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/models/category.dart';

void main() {
  group('ProductModel - fromValues and getters', () {
    test('fromValues sets basic fields and getters', () {
      final p = ProductModel.fromValues(
        id: 'p1',
        name: 'Test Product',
        description: 'desc',
        imageUrl: 'img.png',
        category: [ProductCategory.clothing],
        price: 12.5,
        salePrice: 9.99,
      );

      expect(p.id, 'p1');
      expect(p.name, 'Test Product');
      expect(p.description, 'desc');
      expect(p.imageUrl, 'img.png');
      expect(p.price, 12.5);
      expect(p.salePrice, 9.99);
      expect(p.category, isNotNull);
      expect(p.category!.first, ProductCategory.clothing);
    });

    test('fromValues initializes selectedOptions when options provided', () {
      final p = ProductModel.fromValues(
        id: 'p2',
        options: {
          'Size': ['S', 'M', 'L']
        },
      );

      expect(p.options, isNotNull);
      expect(p.options!['Size'], containsAll(['S', 'M', 'L']));
      // selectedOptions should be initialised (empty map) when options provided
      expect(p.selectedOptions, isNotNull);
      expect(p.selectedOptions!.isEmpty, isTrue);
    });

    test('default fields when using empty constructor', () {
      final p = ProductModel();
      expect(p.id, isA<String>());
      expect(p.id, '');
      expect(p.name, '');
      expect(p.price, 0.0);
      expect(p.salePrice, -1);
      expect(p.quantity, 0);
      expect(p.options, isNull);
      expect(p.selectedOptions, isNull);
    });
  });
}
