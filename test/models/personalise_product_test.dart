import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/personalise_product_model.dart';
import 'package:union_shop/models/product_model.dart';

void main() {
  group('PersonaliseProductModel - text manipulation', () {
    test('setText updates the specified line when index valid', () {
      final base = ProductModel.fromValues(id: 'p1', name: 'P', price: 5.0);
      final model = PersonaliseProductModel();
      // copy base fields into personalise model so price and other fields exist
      base.copyTo(model);

      model.personalisedText = List.filled(2, '');
      model.setText('Hello', 0);
      expect(model.personalisedText[0], 'Hello');
    });

    test('setText ignores out-of-range indices', () {
      final base = ProductModel.fromValues(id: 'p2', name: 'P2', price: 4.0);
      final model = PersonaliseProductModel();
      base.copyTo(model);

      model.personalisedText = List.filled(1, '');
      model.setText('X', -1);
      expect(model.personalisedText[0], '');

      model.setText('Y', 10);
      expect(model.personalisedText[0], '');
    });

    test('setIsLogo assigns isLogo flag once', () {
      final base = ProductModel.fromValues(id: 'p3', name: 'P3', price: 2.0);
      final model = PersonaliseProductModel();
      base.copyTo(model);

      model.setIsLogo(true);
      expect(model.isLogo, isTrue);
    });
  });

  group('PersonaliseProductModel - overallPrice', () {
    test('non-logo pricing uses base price plus per-line surcharge', () {
      final base = ProductModel.fromValues(id: 'pn1', name: 'PN1', price: 10.0);
      final model = PersonaliseProductModel();
      base.copyTo(model);

      model.personalisedText = List.filled(2, '');
      model.setIsLogo(false);

      // base 10 + 2 lines * 2.0 = 14.0
      expect(model.overallPrice(''), closeTo(14.0, 1e-6));
    });

    test('logo pricing returns 3.5 for small logo and 5.0 otherwise', () {
      final base = ProductModel.fromValues(id: 'pl1', name: 'PL1', price: 20.0);
      final model = PersonaliseProductModel();
      base.copyTo(model);

      model.personalisedText = List.filled(1, '');
      model.setIsLogo(true);

      expect(model.overallPrice('Small Logo (Chest)'), closeTo(3.5, 1e-6));
      expect(model.overallPrice('Large Logo'), closeTo(5.0, 1e-6));
    });
  });
}
