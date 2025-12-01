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
}
