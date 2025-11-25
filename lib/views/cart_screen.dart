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
        ]
      ],
    )));
  }
}

class CartWidget extends StatelessWidget {
  final ProductModel product;

  const CartWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(
            product.imageUrl,
            width: 100,
            height: 100,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
              ),
            ],
          ),
          Text('£${(product.price * product.quantity).toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}
