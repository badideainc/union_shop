import 'package:flutter/material.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/models/product_model.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key, required this.product});

  final ProductModel product;

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              height: 100,
              color: Colors.white,
              child: const Column(
                children: [
                  // Top banner
                  TopBanner(),
                  // Main header

                  NavBar(),
                  // Expanded(
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: 10),
                  //     child: Row(
                  //       children: [
                  //         GestureDetector(
                  //           onTap: () {
                  //             navigateToHome(context);
                  //           },
                  //           child: Image.network(
                  //             'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                  //             height: 18,
                  //             fit: BoxFit.cover,
                  //             errorBuilder: (context, error, stackTrace) {
                  //               return Container(
                  //                 color: Colors.grey[300],
                  //                 width: 18,
                  //                 height: 18,
                  //                 child: const Center(
                  //                   child: Icon(Icons.image_not_supported,
                  //                       color: Colors.grey),
                  //                 ),
                  //               );
                  //             },
                  //           ),
                  //         ),
                  //         const Spacer(),
                  //         ConstrainedBox(
                  //           constraints: const BoxConstraints(maxWidth: 600),
                  //           child: Row(
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               IconButton(
                  //                 icon: const Icon(
                  //                   Icons.search,
                  //                   size: 18,
                  //                   color: Colors.grey,
                  //                 ),
                  //                 padding: const EdgeInsets.all(8),
                  //                 constraints: const BoxConstraints(
                  //                   minWidth: 32,
                  //                   minHeight: 32,
                  //                 ),
                  //                 onPressed: placeholderCallbackForButtons,
                  //               ),
                  //               IconButton(
                  //                 icon: const Icon(
                  //                   Icons.person_outline,
                  //                   size: 18,
                  //                   color: Colors.grey,
                  //                 ),
                  //                 padding: const EdgeInsets.all(8),
                  //                 constraints: const BoxConstraints(
                  //                   minWidth: 32,
                  //                   minHeight: 32,
                  //                 ),
                  //                 onPressed: placeholderCallbackForButtons,
                  //               ),
                  //               IconButton(
                  //                 icon: const Icon(
                  //                   Icons.shopping_bag_outlined,
                  //                   size: 18,
                  //                   color: Colors.grey,
                  //                 ),
                  //                 padding: const EdgeInsets.all(8),
                  //                 constraints: const BoxConstraints(
                  //                   minWidth: 32,
                  //                   minHeight: 32,
                  //                 ),
                  //                 onPressed: placeholderCallbackForButtons,
                  //               ),
                  //               IconButton(
                  //                 icon: const Icon(
                  //                   Icons.menu,
                  //                   size: 18,
                  //                   color: Colors.grey,
                  //                 ),
                  //                 padding: const EdgeInsets.all(8),
                  //                 constraints: const BoxConstraints(
                  //                   minWidth: 32,
                  //                   minHeight: 32,
                  //                 ),
                  //                 onPressed: placeholderCallbackForButtons,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            // Product details
            Row(
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
                                          style: TextStyle(color: Colors.grey),
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
                  width: MediaQuery.sizeOf(context).width - 500,
                  child: Column(
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Product price
                      Text(
                        "£${product.price.toString()}",
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
                              optionName: product.options?.keys.toList()[0],
                              options: product.options?.values.toList()[0]),
                          QuantityWidget(),
                        ],
                      ),

                      // product.options.forEach((key, value) {
                      //   ProductDropdown(
                      //     options: value,
                      //   );
                      // }),

                      ElevatedButton(
                          onPressed: () {}, child: const Text("ADD TO CART")),
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
                        product.description,
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
            // Container(
            //   color: Colors.white,
            //   padding: const EdgeInsets.all(24),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       // Product image
            //       Container(
            //         height: 300,
            //         width: double.infinity,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(8),
            //           color: Colors.grey[200],
            //         ),
            //         child: ClipRRect(
            //           borderRadius: BorderRadius.circular(8),
            //           child: Image.network(
            //             'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
            //             fit: BoxFit.cover,
            //             errorBuilder: (context, error, stackTrace) {
            //               return Container(
            //                 color: Colors.grey[300],
            //                 child: const Center(
            //                   child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       Icon(
            //                         Icons.image_not_supported,
            //                         size: 64,
            //                         color: Colors.grey,
            //                       ),
            //                       SizedBox(height: 8),
            //                       Text(
            //                         'Image unavailable',
            //                         style: TextStyle(color: Colors.grey),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               );
            //             },
            //           ),
            //         ),
            //       ),

            //       const SizedBox(height: 24),

            //       // Product name
            //       Text(
            //         product.name,
            //         style: const TextStyle(
            //           fontSize: 28,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.black,
            //         ),
            //       ),

            //       const SizedBox(height: 12),

            //       // Product price
            //       Text(
            //         "£${product.price.toString()}",
            //         style: const TextStyle(
            //           fontSize: 24,
            //           fontWeight: FontWeight.bold,
            //           color: Color(0xFF4d2963),
            //         ),
            //       ),

            //       const SizedBox(height: 24),

            //       // Product description
            //       const Text(
            //         'Description',
            //         style: TextStyle(
            //           fontSize: 18,
            //           fontWeight: FontWeight.w600,
            //           color: Colors.black,
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //       Text(
            //         product.description,
            //         style: const TextStyle(
            //           fontSize: 16,
            //           color: Colors.grey,
            //           height: 1.5,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // Footer
            const Footer(),
          ],
        ),
      ),
    );
  }
}

class ProductDropdown extends StatelessWidget {
  final String? optionName;
  final List<String>? options;

  const ProductDropdown(
      {super.key, required this.optionName, required this.options});

  @override
  Widget build(BuildContext context) {
    if (options == null) {
      return const SizedBox(
        width: double.infinity,
        height: 25,
      );
    }

    return Column(
      children: [
        Text(optionName!),
        DropdownButton(
            hint: Text(textAlign: TextAlign.left, options![0]),
            items: getDropdownOptions(options!),
            onChanged: (String? newValue) {})
      ],
    );
  }

  List<DropdownMenuItem<String>> getDropdownOptions(Iterable<String> options) {
    return options
        .map((String page) =>
            DropdownMenuItem<String>(value: page, child: Text(page)))
        .toList();
  }

  void changeCategory(String newValue) {}
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
