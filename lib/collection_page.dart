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
      final ProductCategory? stringCat =
          categoryFromString(item['category']?.toString());

      //Add the id if the category matches
      if (stringCat == category) {
        //Add product to display list
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ProductDropdown(optionName: 'Filter', options: ["Test"]),
                      ProductDropdown(optionName: 'Sort', options: ["Test"]),
                      Text('0 products'),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
