import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/repositories/pricing_repository.dart';
import 'package:union_shop/models/product_model.dart';

void main() {
  group('PricingRepository - empty list', () {
    test('returns 0.0 for empty list', () {
      final repo = PricingRepository();
      final total = repo.calculateTotalPrice([]);
      expect(total, 0.0);
    });
  });

  group('PricingRepository - single product price', () {
    test('calculates price * quantity when no salePrice', () {
      final repo = PricingRepository();
      final p = ProductModel.fromValues(id: 'p1', price: 4.5);
      p.setQuantity(3);
      final total = repo.calculateTotalPrice([p]);
      expect(total, closeTo(13.5, 1e-6));
    });
  });

  group('PricingRepository - salePrice preferred', () {
    test('uses salePrice when salePrice >= 0', () {
      final repo = PricingRepository();
      final p = ProductModel.fromValues(id: 'p2', price: 10.0, salePrice: 7.5);
      p.setQuantity(2);
      final total = repo.calculateTotalPrice([p]);
      expect(total, closeTo(15.0, 1e-6));
    });
  });
}
