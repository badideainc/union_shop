import 'package:flutter/material.dart';
import 'package:union_shop/json_parser.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/models/category.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/main.dart';

class CollectionPage extends StatefulWidget {
  final ProductCategory category;

  const CollectionPage({super.key, required this.category});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  late final Future<List<ProductModel>> _futureProducts;

  final TextEditingController _dropdownController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureProducts = _fetchProductsForCategory(widget.category);
  }

  Future<List<ProductModel>> _fetchProductsForCategory(
      ProductCategory category) async {
    final List<Map<String, dynamic>> products = await loadProductData();

    List<Future<ProductModel>> futures = [];

    for (final item in products) {
      final dynamic catField = item['category'];

      bool matches = false;

      if (catField is List) {
        for (final c in catField) {
          final ProductCategory? parsed = categoryFromString(c?.toString());
          if (parsed == category) {
            matches = true;
            break;
          }
        }
      } else {
        final ProductCategory? stringCat =
            categoryFromString(catField?.toString());
        if (stringCat == category) matches = true;
      }

      // Add the id if the category matches
      if (matches) {
        futures.add(ProductModel.productFromJson(item['id'].toString()));
      }
    }

    return await Future.wait(futures);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Header(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    categoryTitle(widget.category),
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<List<ProductModel>>(
                    future: _futureProducts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child:
                              Text('Error loading products: ${snapshot.error}'),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Controls row: two dropdowns and the live product count
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProductDropdown(
                                  optionName: 'Filter',
                                  options: const ["Test"],
                                  dropdownController: _dropdownController),
                              ProductDropdown(
                                  optionName: 'Sort',
                                  options: const ["Test"],
                                  dropdownController: _dropdownController),
                              Text('${snapshot.data?.length ?? 0} products'),
                            ],
                          ),

                          const SizedBox(height: 24),

                          if (snapshot.data!.isEmpty) ...[
                            const Text('No products found'),
                          ] else ...[
                            // Minimal listing: ProductCards for each product
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount:
                                  MediaQuery.of(context).size.width > 600
                                      ? 2
                                      : 1,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 48,
                              children: snapshot.data!
                                  .map((p) => ProductCard(productID: p.id))
                                  .toList(),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
