import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/print_shack/print_personal_page.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/models/cart_model.dart';

void main() {
  group('PrintPersonalisationPage - initial loading', () {
    testWidgets('shows loading indicator while base product loads',
        (tester) async {
      await tester.pumpWidget(const MediaQuery(
        data: MediaQueryData(size: Size(1200, 900)),
        child: MaterialApp(home: PrintPersonalisationPage()),
      ));

      // Immediately after pump, the FutureBuilder will show a loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('PrintPersonalisationPage - after load', () {
    testWidgets('shows form or error message after base product finishes',
        (tester) async {
      await tester.pumpWidget(const MediaQuery(
        data: MediaQueryData(size: Size(1200, 900)),
        child: MaterialApp(home: PrintPersonalisationPage()),
      ));

      // Wait for the FutureBuilder to complete (either success or error).
      // We'll pump frames for up to a few seconds.
      var attempts = 0;
      while (
          attempts < 20 && tester.any(find.byType(CircularProgressIndicator))) {
        await tester.pump(const Duration(milliseconds: 200));
        attempts++;
      }

      // If the product failed to load, the page shows an error message.
      if (find.text('Error loading product').evaluate().isNotEmpty) {
        expect(find.text('Error loading product'), findsOneWidget);
        return;
      }

      // Otherwise we expect to see the Personalisation UI: title, price and at least one TextField
      expect(find.text('Personalisation'), findsOneWidget);
      // Price text should contain a pound sign '£'
      expect(find.textContaining('£'), findsWidgets);
      expect(find.byType(TextField), findsWidgets);
    });
  });

  group('PrintPersonalisationPage - add to cart', () {
    testWidgets('pressing ADD TO CART adds item to cart', (tester) async {
      final cart = CartModel();
      final base = ProductModel.fromValues(
        id: 'print_item',
        name: 'Print Item',
        price: 3.0,
      );

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(size: Size(1200, 900)),
        child: ChangeNotifierProvider.value(
          value: cart,
          child: MaterialApp(
              home: PrintPersonalisationPage(
                  baseProductFuture: Future.value(base))),
        ),
      ));

      // Allow future to resolve and widgets to build
      await tester.pumpAndSettle();

      // Ensure ADD TO CART button is present
      final addFinder = find.text('ADD TO CART');
      expect(addFinder, findsOneWidget);

      await tester.tap(addFinder);
      await tester.pumpAndSettle();

      expect(cart.items.length, 1);
      expect(cart.items.first.id, 'print_item');
    });
  });
}
