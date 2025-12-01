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
}
