import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/category.dart';

void main() {
  group('Category - titles', () {
    test('categoryTitle returns expected human labels', () {
      expect(categoryTitle(ProductCategory.clothing), 'Clothing');
      expect(categoryTitle(ProductCategory.merchandise), 'Merchandise');
      expect(categoryTitle(ProductCategory.halloween), 'Halloween 🎃');
      expect(categoryTitle(ProductCategory.signatureAndEssentialsRange),
          'Signature & Essentials Range');
      expect(categoryTitle(ProductCategory.portsmouthCityCollection),
          'Portsmouth City Collection');
      expect(categoryTitle(ProductCategory.prideCollection),
          'Pride Collection 🏳️‍🌈');
      expect(categoryTitle(ProductCategory.graduation), 'Graduation 🎓');
      expect(categoryTitle(ProductCategory.personalised), 'Personalised Items');
      expect(categoryTitle(ProductCategory.sale), 'SALE!');
    });
  });

  group('Category - parsing', () {
    test('categoryFromString parses known enum-style strings', () {
      expect(categoryFromString('clothing'), ProductCategory.clothing);
      expect(categoryFromString('merchandise'), ProductCategory.merchandise);
      expect(categoryFromString('halloween'), ProductCategory.halloween);
      expect(categoryFromString('signatureAndEssentialsRange'),
          ProductCategory.signatureAndEssentialsRange);
      expect(categoryFromString('portsmouthCityCollection'),
          ProductCategory.portsmouthCityCollection);
      expect(categoryFromString('prideCollection'),
          ProductCategory.prideCollection);
      expect(categoryFromString('graduation'), ProductCategory.graduation);
      expect(categoryFromString('personalised'), ProductCategory.personalised);
      expect(categoryFromString('sale'), ProductCategory.sale);
    });

    test('categoryFromString returns null for unknown strings', () {
      expect(categoryFromString('not-a-category'), isNull);
      expect(categoryFromString(''), isNull);
      expect(categoryFromString(null), isNull);
    });
  });

  group('Category - path helpers', () {
    test('categoryToPath and pathToCategory map correctly and round-trip', () {
      for (final c in ProductCategory.values) {
        final path = categoryToPath(c);
        final parsed = pathToCategory(path);
        expect(parsed, c, reason: 'Round-trip for $c failed (path: $path)');
      }

      // Known specific mappings
      expect(categoryToPath(ProductCategory.signatureAndEssentialsRange),
          'signature');
      expect(categoryToPath(ProductCategory.portsmouthCityCollection),
          'portsmouth');

      // Unknown path returns null
      expect(pathToCategory('not-a-path'), isNull);
    });
  });
}
