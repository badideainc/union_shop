import 'package:flutter/material.dart';
import 'package:union_shop/print_shack/print_about_page.dart';
import 'package:union_shop/main.dart ';

class PrintPersonalisationPage extends StatelessWidget {
  const PrintPersonalisationPage({super.key});

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
          const SizedBox(
              height: 250,
              child: PrintImage(
                  imageUrl:
                      "https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282")),
          const SizedBox(height: 20),
          const Text("Personalisation",
              style: TextStyle(fontSize: 36, color: Colors.black)),
        ],
      ),
    ));
  }
}
