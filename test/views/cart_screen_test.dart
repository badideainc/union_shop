import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/views/cart_screen.dart';
import 'package:union_shop/models/cart_model.dart';

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
}
