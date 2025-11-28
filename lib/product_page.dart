import 'package:flutter/material.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/cart_model.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.productID});

  final String productID;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  _ProductPageState();

  late final Future<ProductModel> _product;

  final Map<String, TextEditingController> _dropdownControllers = {};

  void _ensureControllers(ProductModel model) {
    final keys = model.options?.keys ?? <String>[];
    for (final key in keys) {
      _dropdownControllers.putIfAbsent(key, () {
        final c = TextEditingController();
        // If the model already has a stored selection for this option, apply it
        final existing = model.selectedOptions?[key];
        if (existing != null && existing.isNotEmpty) c.text = existing;
        return c;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _product = ProductModel.productFromJson(widget.productID);
  }

  @override
  void dispose() {
    // Dispose any dynamically created dropdown controllers.
    for (final c in _dropdownControllers.values) {
      c.dispose();
    }
    _dropdownControllers.clear();
    super.dispose();
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _product,
      builder: (context, AsyncSnapshot<ProductModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return const Text("Error loading product, please try again");
        }
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                const Header(),

                // Product details
                Column(
                  children: [
                    Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Container(
                              width: 450,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[200],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.image_not_supported,
                                              size: 64,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Image unavailable',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        )),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            snapshot.data!.name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 12),

                          if (snapshot.data!.salePrice > 0) ...[
                            Text(
                              "£${snapshot.data!.salePrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              "£${snapshot.data!.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ] else ...[
                            // Product price
                            Text(
                              "£${snapshot.data!.price.toStringAsFixed(2)}",
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
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 20.0,
                            children: [
                              if (snapshot.data!.options != null) ...[
                                // Ensure we have controllers for each option key
                                () {
                                  _ensureControllers(snapshot.data!);
                                  return const SizedBox.shrink();
                                }(),
                                for (final key in snapshot.data!.options!.keys)
                                  ProductDropdown(
                                    optionName: key,
                                    options: snapshot.data!.options![key],
                                    dropdownController:
                                        _dropdownControllers[key]!,
                                    onChanged: (val) {
                                      // Persist the selection into the product model
                                      snapshot.data!
                                          .setSelectedOption(key, val);
                                    },
                                  ),
                              ],
                            ],
                          ),
                          QuantityWidget(product: snapshot.data!),

                          // product.options.forEach((key, value) {
                          //   ProductDropdown(
                          //     options: value,
                          //   );
                          // }),

                          ElevatedButton(
                              onPressed: () {
                                context.read<CartModel>().add(snapshot.data!);
                              },
                              child: const Text("ADD TO CART")),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white),
                            child: const Text("Buy with shop"),
                          ),

                          const SizedBox(height: 24),
                          const Text("More payment options"),

                          const SizedBox(height: 24),
                          // Product description
                          Text(
                            snapshot.data!.description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                // Footer
                const Footer(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProductDropdown extends StatefulWidget {
  final String? optionName;
  final List<String>? options;
  final TextEditingController dropdownController;
  final ValueChanged<String>? onChanged;

  const ProductDropdown(
      {super.key,
      required this.optionName,
      required this.options,
      required this.dropdownController,
      this.onChanged});

  @override
  State<ProductDropdown> createState() => _ProductDropdownState();
}

class _ProductDropdownState extends State<ProductDropdown> {
  String? _selected;
  @override
  void initState() {
    super.initState();
    // Initialize internal selected value from the controller if present.
    _selected = widget.dropdownController.text.isEmpty
        ? null
        : widget.dropdownController.text;
    // Rebuild when the controller changes so the Dropdown shows the current value.
    widget.dropdownController.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (!mounted) return;
    final controllerValue = widget.dropdownController.text.isEmpty
        ? null
        : widget.dropdownController.text;
    if (controllerValue != _selected) {
      setState(() {
        _selected = controllerValue;
      });
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.dropdownController.removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.options == null) {
      return const SizedBox(
        height: 25,
      );
    } else {
      return Column(
        children: [
          Text(widget.optionName ?? ''),
          DropdownButton<String>(
            hint: Text(widget.options![0], textAlign: TextAlign.left),
            items: widget.options!
                .map((opt) =>
                    DropdownMenuItem<String>(value: opt, child: Text(opt)))
                .toList(),
            value: _selected,
            onChanged: (String? newValue) {
              if (newValue == null) return;
              // Debug: selection fired
              // ignore: avoid_print
              print('[ProductDropdown] onChanged -> $newValue');
              setState(() {
                _selected = newValue;
              });
              // Update the passed controller so external listeners see the change.
              widget.dropdownController.text = newValue;
              // Notify parent if it wants to react directly to selection changes.
              widget.onChanged?.call(newValue);
            },
          )
        ],
      );
    }
  }
}

class QuantityWidget extends StatefulWidget {
  final ProductModel product;

  const QuantityWidget({super.key, required this.product});

  @override
  State<QuantityWidget> createState() => _QuantityWidgetState();
}

class _QuantityWidgetState extends State<QuantityWidget> {
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
        text: widget.product.quantity > 0
            ? widget.product.quantity.toString()
            : '1');
    _quantityController.addListener(_onQuantityChanged);
  }

  void _onQuantityChanged() {
    final text = _quantityController.text;
    final int value = int.tryParse(text) ?? 1;
    widget.product.setQuantity(value);
    // no need to call setState unless widget displays the value
  }

  @override
  void dispose() {
    _quantityController.removeListener(_onQuantityChanged);
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Quantity"),
        SizedBox(
            width: 80,
            height: 80,
            child: TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
            ))
      ],
    );
  }
}
