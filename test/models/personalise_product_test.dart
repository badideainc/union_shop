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
}
