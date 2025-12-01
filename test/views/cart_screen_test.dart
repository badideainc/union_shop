import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/views/cart_screen.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/product_model.dart';

void main() {
  group('CartScreen - empty cart UI', () {
    testWidgets('shows empty message and continue shopping button',
        (tester) async {
      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(size: Size(1200, 900)),
        child: ChangeNotifierProvider(
          create: (_) => CartModel(),
          child: const MaterialApp(home: CartScreen()),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Your cart is currently empty.'), findsOneWidget);
      expect(find.text('Continue shopping'), findsOneWidget);
    });
  });

  group('CartScreen - non-empty cart UI', () {
    testWidgets('shows product rows, total and checkout button',
        (tester) async {
      final cart = CartModel();
      final p =
          ProductModel.fromValues(id: 'p1', name: 'Print Item', price: 3.0);
      p.setQuantity(2);
      cart.add(p);

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(size: Size(1200, 900)),
        child: ChangeNotifierProvider.value(
          value: cart,
          child: const MaterialApp(home: CartScreen()),
        ),
      ));

      await tester.pumpAndSettle();

      // Product row shows name and quantity
      expect(find.text('Print Item (x2)'), findsOneWidget);

      // Total should be displayed (2 * 3.0 = 6.00)
      expect(find.textContaining('Total: £6.00'), findsOneWidget);

      // Checkout button present
      expect(find.text('CHECK OUT'), findsOneWidget);
    });
  });

  group('CartWidget - remove button', () {
    testWidgets('tapping remove deletes the item and shows empty UI',
        (tester) async {
      final cart = CartModel();
      final p = ProductModel.fromValues(
          id: 'p-remove', name: 'Removable', price: 2.0);
      p.setQuantity(1);
      cart.add(p);

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(size: Size(1200, 900)),
        child: ChangeNotifierProvider.value(
          value: cart,
          child: const MaterialApp(home: CartScreen()),
        ),
      ));

      await tester.pumpAndSettle();

      // Ensure the product row is visible
      expect(find.text('Removable (x1)'), findsOneWidget);

      final removeButton = find.widgetWithText(TextButton, 'remove');
      expect(removeButton, findsOneWidget);

      await tester.ensureVisible(removeButton);
      await tester.tap(removeButton);
      await tester.pumpAndSettle();

      // Cart model should be empty and UI should show empty message
      expect(cart.items.isEmpty, isTrue);
      expect(find.text('Your cart is currently empty.'), findsOneWidget);
    });
  });

  group('CartWidget - update quantity', () {
    testWidgets('entering quantity and tapping Update changes cart quantity',
        (tester) async {
      final cart = CartModel();
      final p = ProductModel.fromValues(
          id: 'p-update', name: 'Updatable', price: 2.0);
      p.setQuantity(1);
      cart.add(p);

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(size: Size(1200, 900)),
        child: ChangeNotifierProvider.value(
          value: cart,
          child: const MaterialApp(home: CartScreen()),
        ),
      ));

      await tester.pumpAndSettle();

      // Find the quantity TextField and enter '3'
      final qtyField = find.byType(TextField).first;
      expect(qtyField, findsOneWidget);

      await tester.enterText(qtyField, '3');
      await tester.pumpAndSettle();

      final updateButton = find.widgetWithText(ElevatedButton, 'Update');
      expect(updateButton, findsOneWidget);

      // Ensure visible then tap
      await tester.ensureVisible(updateButton);
      await tester.tap(updateButton);
      await tester.pumpAndSettle();

      // Cart model should update quantity
      expect(cart.items.first.quantity, 3);

      // Total should reflect 3 * 2.0 = 6.00
      expect(find.textContaining('Total: £6.00'), findsOneWidget);
    });
  });

  group('CartWidget - price display uses salePrice', () {
    testWidgets('uses salePrice when available for total calculation',
        (tester) async {
      final cart = CartModel();
      final p = ProductModel.fromValues(
          id: 'p-sale', name: 'OnSale', price: 10.0, salePrice: 6.0);
      p.setQuantity(2);
      cart.add(p);

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(size: Size(1200, 900)),
        child: ChangeNotifierProvider.value(
          value: cart,
          child: const MaterialApp(home: CartScreen()),
        ),
      ));

      await tester.pumpAndSettle();

      // Total should reflect salePrice * quantity = 6.0 * 2 = 12.00
      expect(find.textContaining('Total: £12.00'), findsOneWidget);
    });
  });
}
