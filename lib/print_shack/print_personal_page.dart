import 'package:flutter/material.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/print_shack/print_about_page.dart';
import 'package:union_shop/product_page.dart';

class PrintPersonalisationPage extends StatefulWidget {
  const PrintPersonalisationPage({super.key});

  @override
  State<PrintPersonalisationPage> createState() =>
      _PrintPersonalisationPageState();
}

class _PrintPersonalisationPageState extends State<PrintPersonalisationPage> {
  late final TextEditingController _dropdownController;

  final Map<String, int> linesOptions = {
    "One Line Per Text": 1,
    "Two Lines Per Text": 2,
    "Three Lines Per Text": 3,
    "Four Lines Per Text": 4,
    "Small Logo (Chest)": 1,
    "Large Logo (Back)": 1
  };

  @override
  void initState() {
    super.initState();
    _dropdownController = TextEditingController();
    // Initialize with the first option so the UI shows a sensible default.
    if (linesOptions.isNotEmpty) {
      _dropdownController.text = linesOptions.keys.first;
    }
    _dropdownController.addListener(_onDropdownChange);
  }

  void _onDropdownChange() {
    // Rebuild when the controller value changes so the UI reflects the
    // currently-selected dropdown option (used by ProductDropdown).
    setState(() {});
  }

  @override
  void dispose() {
    _dropdownController.removeListener(_onDropdownChange);
    _dropdownController.dispose();
    super.dispose();
  }

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
              optionName: "Per Line: ${_dropdownController.text}",
              options: linesOptions.keys.toList(),
              dropdownController: _dropdownController),
          const SizedBox(height: 24),
          //Will need to iterate to add more lines if user selects more than one line
          for (int i = 0;
              i <
                  (linesOptions[_dropdownController.text] != null
                      ? linesOptions[_dropdownController.text]!
                      : 1);
              i++) ...[
            Text(
              "Personalisation Line ${i + 1}:",
              style: const FooterText(16),
            ),
            const TextField(),
          ],
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
