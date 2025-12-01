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
}
