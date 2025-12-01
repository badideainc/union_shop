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
}
