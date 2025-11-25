import 'package:flutter/material.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/models/cart_model.dart';

class CartScreen extends StatefulWidget {
  final CartModel cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        const Header(),
        Text(
          'Your Cart',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        if (widget.cart.items.isEmpty) ...[
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
          )
        ]
      ],
    )));
  }
}
