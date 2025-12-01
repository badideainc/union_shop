import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/cart_model.dart';

void main() {
  group('Product Page Tests', () {
    Widget createTestWidget() {
      // Use an injected ProductModel so tests do not rely on asset loading.
      final product = ProductModel.fromValues(
        id: 'grad_bear',
        name: 'Graduation Bear',
        price: 15.0,
        salePrice: -1,
        options: {
          'Color': ['Brown']
        },
        description: 'A plush graduation bear',
        imageUrl: '',
      );

      return MaterialApp(
        home: ProductPage(
          productID: 'grad_bear',
          productFuture: Future.value(product),
        ),
      );
    }

    testWidgets('should display product page with basic elements', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check that product name and price from assets are present
      expect(find.text('Graduation Bear'), findsOneWidget);
      expect(find.text('£15.00'), findsOneWidget);
    });

    testWidgets('should display product option label', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Graduation Bear in assets has an options map with a 'Color' key
      expect(find.text('Color'), findsOneWidget);
    });

    testWidgets('should display header icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check that header icons are present
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check that footer contains the expected sections
      expect(find.text('Opening Hours'), findsOneWidget);
      expect(find.text('Latest Offers'), findsOneWidget);
    });

    testWidgets('tapping ADD TO CART adds product to CartModel',
        (tester) async {
      final cart = CartModel();

      // Inject the same deterministic product used by createTestWidget
      final product = ProductModel.fromValues(
        id: 'grad_bear',
        name: 'Graduation Bear',
        price: 15.0,
        salePrice: -1,
        options: {
          'Color': ['Brown']
        },
        description: 'A plush graduation bear',
        imageUrl: '',
      );

      // Put the provider inside MaterialApp so ProductPage can read it from context
      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider<CartModel>.value(
          value: cart,
          child: ProductPage(
            productID: 'grad_bear',
            productFuture: Future.value(product),
          ),
        ),
      ));

      await tester.pumpAndSettle();

      // Find the ADD TO CART button and ensure it's visible before tapping
      final addFinder = find.widgetWithText(ElevatedButton, 'ADD TO CART');
      expect(addFinder, findsOneWidget);
      await tester.ensureVisible(addFinder);
      await tester.pumpAndSettle();

      await tester.tap(addFinder);
      await tester.pumpAndSettle();

      // CartModel should have one item with the expected id
      expect(cart.items.length, equals(1));
      expect(cart.items.first.id, equals('grad_bear'));
    });
  });

  group('ProductDropdown Tests', () {
    testWidgets('shows option label and hint', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProductDropdown(
            optionName: 'Color',
            options: const ['Red', 'Blue'],
            dropdownController: controller,
            onChanged: (_) {},
          ),
        ),
      ));

      await tester.pumpAndSettle();

      // The option name label should be present and the first option shown as hint
      expect(find.text('Color'), findsOneWidget);
      expect(find.text('Red'), findsOneWidget);
    });

    testWidgets('selecting an option updates controller and calls onChanged',
        (tester) async {
      final controller = TextEditingController();
      String? selected;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProductDropdown(
            optionName: 'Size',
            options: const ['Small', 'Large'],
            dropdownController: controller,
            onChanged: (val) => selected = val,
          ),
        ),
      ));

      await tester.pumpAndSettle();

      // Open the dropdown menu
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Tap the second option
      await tester.tap(find.text('Large').last);
      await tester.pumpAndSettle();

      expect(controller.text, equals('Large'));
      expect(selected, equals('Large'));
    });
  });

  group('Quantity Widget Tests', () {
    testWidgets('initializes with product quantity and updates model',
        (tester) async {
      final product = ProductModel.fromValues(
          id: 'q1', name: 'Qty Test', price: 5.0, salePrice: -1);
      product.setQuantity(1);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: QuantityWidget(product: product),
        ),
      ));

      await tester.pumpAndSettle();

      // There is a single TextField in QuantityWidget
      final tf = find.byType(TextField);
      expect(tf, findsOneWidget);

      // Change the quantity to 4
      await tester.enterText(tf, '4');
      await tester.pumpAndSettle();

      expect(product.quantity, equals(4));
    });

    testWidgets('handles non-numeric input by falling back to 1',
        (tester) async {
      final product = ProductModel.fromValues(
          id: 'q2', name: 'Qty Test 2', price: 6.0, salePrice: -1);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: QuantityWidget(product: product),
        ),
      ));

      await tester.pumpAndSettle();

      final tf = find.byType(TextField);
      expect(tf, findsOneWidget);

      // Enter invalid text; controller listener will parse and fallback to 1
      await tester.enterText(tf, 'abc');
      await tester.pumpAndSettle();

      expect(product.quantity, equals(1));
    });
  });

  group('Image Fallback Tests', () {
    testWidgets('image errorBuilder shows placeholder', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'nonexistent_image.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Image unavailable',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
      expect(find.text('Image unavailable'), findsOneWidget);
    });
  });
}
