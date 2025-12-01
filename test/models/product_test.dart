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

  group('ProductModel - copyTo and clone', () {
    test('copyTo produces an independent deep copy', () {
      final original = ProductModel.fromValues(
        id: 'orig1',
        name: 'Original',
        price: 5.0,
        options: {
          'Size': ['S', 'M']
        },
      );

      // populate mutable fields
      original.setSelectedOption('Size', 'S');
      original.setQuantity(3);

      final target = ProductModel();
      original.copyTo(target);

      // basic equality of public fields
      expect(target.id, original.id);
      expect(target.name, original.name);
      expect(target.price, original.price);

      // ensure data copied
      expect(target.options, isNotNull);
      expect(target.options!['Size']![0], 'S');
      expect(target.selectedOptions!['Size'], 'S');
      expect(target.quantity, 3);

      // mutate the target and ensure original is unchanged (deep copy)
      target.setQuantity(1);
      target.setSelectedOption('Size', 'M');
      target.options!['Size']![0] = 'XL';

      expect(original.quantity, 3);
      expect(original.selectedOptions!['Size'], 'S');
      expect(original.options!['Size']![0], 'S');
    });

    test('clone returns a deep-cloned snapshot', () {
      final src = ProductModel.fromValues(
        id: 'src1',
        name: 'Src',
        price: 7.0,
        options: {
          'Color': ['Red', 'Blue']
        },
      );
      src.setSelectedOption('Color', 'Red');
      src.setQuantity(2);

      final cl = src.clone();

      // same field values
      expect(cl.id, src.id);
      expect(cl.name, src.name);
      expect(cl.price, src.price);
      expect(cl.quantity, src.quantity);
      expect(cl.selectedOptions!['Color'], 'Red');

      // mutate clone -> source unchanged
      cl.setQuantity(0);
      cl.setSelectedOption('Color', 'Blue');
      cl.options!['Color']![0] = 'Green';

      expect(src.quantity, 2);
      expect(src.selectedOptions!['Color'], 'Red');
      expect(src.options!['Color']![0], 'Red');
    });
  });
}
