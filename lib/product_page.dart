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

  final TextEditingController _dropdownController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _product = ProductModel.productFromJson(widget.productID);
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

                          Row(
                            spacing: 20.0,
                            children: [
                              ProductDropdown(
                                optionName:
                                    snapshot.data!.options?.keys.toList()[0],
                                options:
                                    snapshot.data!.options?.values.toList()[0],
                                dropdownController: _dropdownController,
                              ),
                              QuantityWidget(),
                            ],
                          ),

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

  const ProductDropdown(
      {super.key,
      required this.optionName,
      required this.options,
      required this.dropdownController});

  @override
  State<ProductDropdown> createState() => _ProductDropdownState();
}

class _ProductDropdownState extends State<ProductDropdown> {
  @override
  void initState() {
    super.initState();
    // Rebuild when the controller changes so the Dropdown shows the current value.
    widget.dropdownController.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
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
            value: widget.dropdownController.text.isEmpty
                ? null
                : widget.dropdownController.text,
            onChanged: (String? newValue) {
              if (newValue == null) return;
              widget.dropdownController.text = newValue;
            },
          )
        ],
      );
    }
  }
}

class QuantityWidget extends StatelessWidget {
  final TextEditingController _quantityController = TextEditingController();

  QuantityWidget({super.key});

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
