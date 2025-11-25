import 'package:flutter/material.dart';
import 'package:union_shop/main.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const Header(),
        Text(
          'Your Cart',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const Text(
          'Continue shopping',
          style: TextStyle(color: Color(0xFF4d2963)),
        ),
      ],
    ));
  }
}
