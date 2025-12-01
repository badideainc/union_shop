import 'dart:async';
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
      final completer = Completer<ProductModel>();

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(size: Size(1200, 900)),
        child: MaterialApp(
            home:
                PrintPersonalisationPage(baseProductFuture: completer.future)),
      ));

      // Immediately the FutureBuilder should show a loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the future and allow widgets to rebuild
      completer.complete(ProductModel.fromValues(
          id: 'print_item', name: 'Print Item', price: 3.0));
      await tester.pumpAndSettle();

      // After completion the Personalisation UI should be visible
      expect(find.text('Personalisation'), findsOneWidget);
    });
  });

  group('PrintPersonalisationPage - after load', () {
    testWidgets('shows form after base product finishes', (tester) async {
      final base = ProductModel.fromValues(
          id: 'print_item', name: 'Print Item', price: 3.0);

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(size: Size(1200, 900)),
        child: MaterialApp(
            home: PrintPersonalisationPage(
                baseProductFuture: Future.value(base))),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Personalisation'), findsOneWidget);
      expect(find.textContaining('£'), findsWidgets);
      expect(find.byType(TextField), findsWidgets);
    });
  });

  group('PrintPersonalisationPage - add to cart', () {
    testWidgets('pressing ADD TO CART adds item to cart', (tester) async {
      final cart = CartModel();
      final base = ProductModel.fromValues(
          id: 'print_item', name: 'Print Item', price: 3.0);

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(size: Size(1200, 900)),
        child: ChangeNotifierProvider.value(
          value: cart,
          child: MaterialApp(
              home: PrintPersonalisationPage(
                  baseProductFuture: Future.value(base))),
        ),
      ));

      await tester.pumpAndSettle();

      final addFinder = find.text('ADD TO CART');
      expect(addFinder, findsOneWidget);

      // Ensure the button is visible (page may be scrollable) before tapping
      await tester.ensureVisible(addFinder);
      await tester.pumpAndSettle();
      await tester.tap(addFinder);
      await tester.pumpAndSettle();

      expect(cart.items.length, 1);
      expect(cart.items.first.id, 'print_item');
    });
  });
}
