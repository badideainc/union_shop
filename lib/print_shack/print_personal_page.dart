import 'package:flutter/material.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/print_shack/print_about_page.dart';
import 'package:union_shop/product_page.dart';

class PrintPersonalisationPage extends StatelessWidget {
  PrintPersonalisationPage({super.key});

  final Map<String, int> linesOptions = {
    "One Line Per Text": 1,
    "Two Lines Per Text": 2,
    "Three Lines Per Text": 3,
    "Four Lines Per Text": 4,
    "Small Logo (Chest)": 1,
    "Large Logo (Back)": 1
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const Header(),
          const SizedBox(
              height: 250,
              child: PrintImage(
                  imageUrl:
                      "https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282")),
          const SizedBox(height: 20),
          const Text("Personalisation",
              style: TextStyle(fontSize: 36, color: Colors.black)),
          const SizedBox(height: 12),

          // Product price
          const Text(
            "£3.00",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4d2963),
            ),
          ),

          const Text(
            "Tax included.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          ProductDropdown(
              optionName: "Per Line: One Line of Text",
              options: linesOptions.keys.toList()),
          const SizedBox(height: 24),
          //Will need to iterate to add more lines if user selects more than one line
          const Text(
            "Personalisation Line 1:",
            style: FooterText(16),
          ),
          const TextField(),
          const SizedBox(height: 24),
          QuantityWidget(),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: () {}, child: const Text("ADD TO CART")),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              """

£3 for one line of text! £5 for two!

One line of text is 10 characters.

Please ensure all spellings are correct before submitting your purchase as we will print your item with the exact wording you provide. We will not be responsible for any incorrect spellings printed onto your garment. Personalised items do not qualify for refunds.
""",
              style: FooterText(16),
            ),
          ),
          const Footer(),
        ],
      ),
    ));
  }
}

// class PrintDropdown extends ProductDropdown {
//   final Map<String, int> linesOptions;

//   PrintDropdown({
//     super.optionName,
//     super.options,
//     List<int>? linePerTextOptions,
//     Map<String, int>? linesOptions,
//     super.key,
//   }) : linesOptions = linesOptions ??
//             ((options != null && linePerTextOptions != null)
//                 ? Map<String, int>.fromIterables(options, linePerTextOptions)
//                 : const <String, int>{});
// }
