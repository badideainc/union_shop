import 'package:flutter/material.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/print_shack/print_about_page.dart';
import 'package:union_shop/product_page.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/personalise_product_model.dart';
import 'package:union_shop/models/product_model.dart';

class PrintPersonalisationPage extends StatefulWidget {
  /// Optional injectable base product future for testing.
  final Future<ProductModel>? baseProductFuture;

  const PrintPersonalisationPage({super.key, this.baseProductFuture});

  @override
  State<PrintPersonalisationPage> createState() =>
      _PrintPersonalisationPageState();
}

class _PrintPersonalisationPageState extends State<PrintPersonalisationPage> {
  late final TextEditingController _dropdownController;
  late String _selectedOption;
  final List<TextEditingController> _lineControllers = [];
  late PersonaliseProductModel _productModel;
  late final Future<ProductModel> _baseProductFuture;
  bool _baseCopied = false;

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
      _selectedOption = linesOptions.keys.first;
      _dropdownController.text = _selectedOption;
    }
    // initialize controllers for the initial selection
    final initialCount = linesOptions[_selectedOption] ?? 1;
    for (var i = 0; i < initialCount; i++) {
      _lineControllers.add(TextEditingController());
    }
    // initialize the product model for this page and keep it in sync
    _productModel = PersonaliseProductModel();
    _productModel.personalisedText = List.filled(initialCount, '');
    _productModel.setIsLogo(_selectedOption.toLowerCase().contains('logo'));
    // Start loading the base product data from JSON for this page.
    _baseProductFuture =
        widget.baseProductFuture ?? ProductModel.productFromJson('print_item');
    for (var i = 0; i < _lineControllers.length; i++) {
      final idx = i;
      _lineControllers[idx].addListener(() {
        _productModel.personalisedText[idx] = _lineControllers[idx].text;
        setState(() {});
      });
    }
  }

  void _onDropdownChange() {
    final selected = _selectedOption;
    final newCount = linesOptions[selected] ?? 1;
    final current = _lineControllers.length;
    if (newCount > current) {
      for (var i = 0; i < newCount - current; i++) {
        final idx = _lineControllers.length;
        final c = TextEditingController();
        _lineControllers.add(c);
        c.addListener(() {
          _productModel.personalisedText[idx] = c.text;
          setState(() {});
        });
      }
    } else if (newCount < current) {
      for (var i = 0; i < current - newCount; i++) {
        _lineControllers.removeLast().dispose();
      }
    }
    // update the model to match the controllers and selected option
    _productModel.personalisedText = List.generate(
      newCount,
      (i) => _lineControllers.length > i ? _lineControllers[i].text : '',
    );
    _productModel.setIsLogo(selected.toLowerCase().contains('logo'));
    setState(() {});
  }

  @override
  void dispose() {
    _dropdownController.dispose();
    for (final c in _lineControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ProductModel>(
        future: _baseProductFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading product'));
          }
          // Ensure the personalise model inherits identifying fields from the
          // base product loaded from JSON. Copy only once to avoid overwriting
          // user changes on rebuilds.
          final base = snapshot.data!;
          if (!_baseCopied) {
            base.copyTo(_productModel);
            _baseCopied = true;
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const Header(),
                const SizedBox(
                    height: 250,
                    child:
                        PrintImage(imageUrl: "assets/images/print_item.jpg")),
                const SizedBox(height: 20),
                const Text("Personalisation",
                    style: TextStyle(fontSize: 36, color: Colors.black)),
                const SizedBox(height: 12),

                // Product price (computed from PersonaliseProductModel)
                Text(
                  '£${_productModel.overallPrice(_selectedOption).toStringAsFixed(2)}',
                  style: const TextStyle(
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
                // Use the shared ProductDropdown component and wire onChanged
                ProductDropdown(
                  optionName: "Per Line: $_selectedOption",
                  options: linesOptions.keys.toList(),
                  dropdownController: _dropdownController,
                  onChanged: (String newValue) {
                    setState(() {
                      _selectedOption = newValue;
                      _dropdownController.text = newValue;
                    });
                    _onDropdownChange();
                  },
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 24),
                //Will need to iterate to add more lines if user selects more than one line
                for (int i = 0;
                    i <
                        (linesOptions[_selectedOption] != null
                            ? linesOptions[_selectedOption]!
                            : 1);
                    i++) ...[
                  Text(
                    "Personalisation Line ${i + 1}:",
                    style: const FooterText(16),
                  ),
                  TextField(
                      controller: _lineControllers.length > i
                          ? _lineControllers[i]
                          : null),
                ],
                const SizedBox(height: 24),
                QuantityWidget(product: _productModel),
                const SizedBox(height: 24),
                ElevatedButton(
                    onPressed: () {
                      // Create a snapshot clone so cart entries don't change
                      // when the user keeps editing the page.
                      final clone = PersonaliseProductModel();
                      // copy identifying/base product fields (id, name, price, etc.)
                      _productModel.copyTo(clone);
                      // then copy the personalised-specific data
                      clone.personalisedText =
                          List.from(_productModel.personalisedText);
                      clone.setIsLogo(
                          _selectedOption.toLowerCase().contains('logo'));
                      clone.setQuantity(_productModel.quantity > 0
                          ? _productModel.quantity
                          : 1);
                      context.read<CartModel>().add(clone);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Added personalised item to cart')));
                    },
                    child: const Text("ADD TO CART")),
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
          );
        },
      ),
    );
  }
}
