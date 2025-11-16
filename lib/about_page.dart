import 'package:flutter/material.dart';
import 'package:union_shop/main.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        Container(
          height: 100,
          color: Colors.white,
          child: const Column(children: [
            // Top banner
            TopBanner(),
            // Main header

            NavBar(),
          ]),
        ),
        const Text(
          "About Us",
          style: TextStyle(fontSize: 36, color: Colors.black),
        ),
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("""Welcome to the Union Shop!

We’re dedicated to giving you the very best University branded products, with a range of clothing and merchandise available to shop all year round! We even offer an exclusive personalisation service!

All online purchases are available for delivery or instore collection!

We hope you enjoy our products as much as we enjoy offering them to you. If you have any questions or comments, please don’t hesitate to contact us at hello@upsu.net.

Happy shopping!

The Union Shop & Reception Team​​​​​""",
              style: TextStyle(fontSize: 16, color: Colors.grey)),
        ),
        const Footer(),
      ],
    )));
  }
}
