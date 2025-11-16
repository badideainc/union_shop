import 'package:flutter/material.dart';
import 'package:union_shop/print_shack/print_about_page.dart';

class PrintPersonalisationPage extends StatelessWidget {
  const PrintPersonalisationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              height: 250,
              child: PrintImage(
                  imageUrl:
                      "https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282")),
          SizedBox(height: 20),
          Text("Personalisation",
              style: TextStyle(fontSize: 36, color: Colors.black)),
        ],
      ),
    ));
  }
}
