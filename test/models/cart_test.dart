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

      // Create a lightweight product instance for tests
      final p = ProductModel.fromValues(
        id: 'lanyard',
        name: 'Lanyard',
        price: 2.75,
      );

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

      final p1 = ProductModel.fromValues(
        id: 'grad_hoodie',
        name: 'Grad Hoodie',
        price: 35.0,
        options: {
          'Size': ['S', 'M', 'L', 'XL']
        },
      );
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
      final p = ProductModel.fromValues(
        id: 'city_postcard',
        name: 'City Postcard',
        price: 1.0,
      );

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
      final p = ProductModel.fromValues(
        id: 'city_magnet',
        name: 'City Magnet',
        price: 4.5,
      );

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
      final p = ProductModel.fromValues(
        id: 'city_bookmark',
        name: 'City Bookmark',
        price: 3.0,
      );
      cart.add(p);
      expect(cart.items.length, 1);

      cart.remove('city_bookmark');
      expect(cart.items.isEmpty, true);
    });
  });

  group('CartModel - clear & items immutability', () {
    testWidgets('clear removes all items', (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final cart = CartModel();
      final p = ProductModel.fromValues(
        id: 'city_notebook',
        name: 'City Notebook',
        price: 7.5,
      );
      cart.add(p);
      expect(cart.items.isNotEmpty, true);

      cart.clear();
      expect(cart.items.isEmpty, true);
    });

    testWidgets('items returns an unmodifiable list', (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final cart = CartModel();
      final p = ProductModel.fromValues(
        id: 'city_magnet',
        name: 'City Magnet',
        price: 4.5,
      );
      cart.add(p);
      final items = cart.items;
      expect(() => items.add(p), throwsA(isA<UnsupportedError>()));
    });
  });

  group('CartModel - totalPrice calculation', () {
    testWidgets(
        'totalPrice uses salePrice when available and respects quantity',
        (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final cart = CartModel();

      final pSale = ProductModel.fromValues(
        id: 'classic_sweatshirt_neutral',
        name: 'Classic Sweatshirt - Neutral',
        price: 17.0,
        salePrice: 10.99,
      );
      final pFull = ProductModel.fromValues(
        id: 'city_bookmark',
        name: 'City Bookmark',
        price: 3.0,
      );

      // classic_sweatshirt_neutral has salePrice 10.99, price 17
      // city_bookmark has price 3
      cart.add(pSale); // quantity 1
      cart.add(pFull); // quantity 1

      // increase quantity of sale item
      cart.updateQuantity(pSale.id, 3);

      // expected: salePrice * 3 + price * 1 = 10.99*3 + 3 = 32.97 + 3 = 35.97
      expect(cart.totalPrice, closeTo(35.97, 0.01));
    });

    testWidgets('totalPrice returns 0.0 for empty cart', (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final cart = CartModel();
      expect(cart.totalPrice, 0.0);
    });
  });
}
