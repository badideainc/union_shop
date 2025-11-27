import 'package:flutter/material.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/print_shack/print_about_page.dart';
import 'package:union_shop/product_page.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/personalise_product_model.dart';

class PrintPersonalisationPage extends StatefulWidget {
  const PrintPersonalisationPage({super.key});

  @override
  State<PrintPersonalisationPage> createState() =>
      _PrintPersonalisationPageState();
}

class _PrintPersonalisationPageState extends State<PrintPersonalisationPage> {
  late final TextEditingController _dropdownController;
  final List<TextEditingController> _lineControllers = [];
  late PersonaliseProductModel _productModel;

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
    // initialize controllers for the initial selection
    final initialCount = linesOptions[_dropdownController.text] ?? 1;
    for (var i = 0; i < initialCount; i++) {
      _lineControllers.add(TextEditingController());
    }
    // initialize the product model for this page and keep it in sync
    _productModel = PersonaliseProductModel();
    _productModel.personalisedText = List.filled(initialCount, '');
    _productModel
        .setIsLogo(_dropdownController.text.toLowerCase().contains('logo'));
    for (var i = 0; i < _lineControllers.length; i++) {
      final idx = i;
      _lineControllers[idx].addListener(() {
        _productModel.personalisedText[idx] = _lineControllers[idx].text;
        setState(() {});
      });
    }
  }

  void _onDropdownChange() {
    // Rebuild when the controller value changes so the UI reflects the
    // currently-selected dropdown option (used by ProductDropdown).
    // adjust controllers to match new count
    final selected = _dropdownController.text;
    final newCount = linesOptions[selected] ?? 1;
    final current = _lineControllers.length;
    if (newCount > current) {
      for (var i = 0; i < newCount - current; i++) {
        _lineControllers.add(TextEditingController());
      }
    } else if (newCount < current) {
      for (var i = 0; i < current - newCount; i++) {
        _lineControllers.removeLast().dispose();
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _dropdownController.removeListener(_onDropdownChange);
    _dropdownController.dispose();
    for (final c in _lineControllers) {
      c.dispose();
    }
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
            TextField(
                controller:
                    _lineControllers.length > i ? _lineControllers[i] : null),
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
