import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/product_model.dart';

void main() {
  group('CartModel - add / merge / remove / quantity', () {
    testWidgets(
        'add creates a snapshot and increments quantity for identical product',
        (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final cart = CartModel();

      // Load a real product from assets
      final p = await ProductModel.productFromJson('lanyard');

      // initial add
      cart.add(p);
      expect(cart.items.length, 1);
      expect(cart.items.first.id, 'lanyard');
      expect(cart.items.first.quantity, 1);

      // add same product (no selected options) should increment quantity
      cart.add(p);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 2);
    });

    testWidgets(
        'add keeps separate line for same id but different selected options',
        (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final cart = CartModel();

      final p1 = await ProductModel.productFromJson('grad_hoodie');
      final p2 = p1.clone();
      p2.setSelectedOption('Size', 'L');

      cart.add(p1);
      cart.add(p2);

      expect(cart.items.length, 2);
      // quantities both are 1
      expect(cart.items[0].quantity, 1);
      expect(cart.items[1].quantity, 1);
    });

    testWidgets('decrease reduces quantity and removes when zero',
        (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final cart = CartModel();
      final p = await ProductModel.productFromJson('city_postcard');

      cart.add(p);
      cart.add(p);
      expect(cart.items.first.quantity, 2);

      cart.decrease('city_postcard');
      expect(cart.items.first.quantity, 1);

      cart.decrease('city_postcard');
      expect(cart.items.where((it) => it.id == 'city_postcard').isEmpty, true);
    });

    testWidgets('updateQuantity sets quantity or removes when <=0',
        (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final cart = CartModel();
      final p = await ProductModel.productFromJson('city_magnet');

      cart.add(p);
      expect(cart.items.first.quantity, 1);

      cart.updateQuantity('city_magnet', 5);
      expect(cart.items.first.quantity, 5);

      cart.updateQuantity('city_magnet', 0);
      expect(cart.items.where((it) => it.id == 'city_magnet').isEmpty, true);
    });

    testWidgets('remove removes item regardless of quantity', (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final cart = CartModel();
      final p = await ProductModel.productFromJson('city_bookmark');
      cart.add(p);
      expect(cart.items.length, 1);

      cart.remove('city_bookmark');
      expect(cart.items.isEmpty, true);
    });
  });
}
