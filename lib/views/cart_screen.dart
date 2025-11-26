import 'package:flutter/material.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        const Header(),
        Text(
          'Your Cart',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        if (cart.items.isEmpty) ...[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Your cart is currently empty.'),
          ),
          const NavButton(optionName: "Continue shopping", url: "/collection"),
        ] else ...[
          const Text(
            'Continue shopping',
            style: TextStyle(color: Color(0xFF4d2963)),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Product'),
              Text('Price'),
            ],
          ),
          Column(
            children: [
              for (final product in cart.items) CartWidget(product: product),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: £${cart.totalPrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ImportButtonStyle(),
            child: const Text('CHECK OUT'),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.deepPurpleAccent),
                    foregroundColor: WidgetStateProperty.all(Colors.white)),
                child: const Text("shop"),
              ),
              ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.black),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  child: const Text("G Pay")),
            ],
          )
        ],
        const SizedBox(height: 24),
        const Footer(),
      ],
    )));
  }
}

class CartWidget extends StatefulWidget {
  final ProductModel product;

  const CartWidget({super.key, required this.product});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  late final TextEditingController _qtyController;

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController();
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(
            product.imageUrl,
            width: 100,
            height: 100,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              );
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${product.name} (x${product.quantity})',
              ),
              if (product.options != null && product.options!.isNotEmpty)
                Text(
                  product.options!.entries
                      .map((e) => '${e.key}: ${e.value}')
                      .join(', '),
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              // Remove button: remove the product from the cart immediately
              TextButton(
                onPressed: () {
                  final cart = context.read<CartModel>();
                  cart.remove(product.id);
                },
                child: const Text('remove'),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Quantity'),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 72,
                    child: TextField(
                      controller: _qtyController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: product.quantity > 0
                            ? product.quantity.toString()
                            : '1',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text('£${(product.price * product.quantity).toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}
