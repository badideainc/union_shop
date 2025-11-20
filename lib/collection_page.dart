import 'package:flutter/material.dart';
import 'package:union_shop/json_parser.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/models/category.dart';

class CollectionPage extends StatefulWidget {
  final Category category;

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
      Category category) async {
    final List<Map<String, dynamic>> products = await loadProductData();

    List<Future<ProductModel>> futures = [];

    for (final item in products) {
      final Category? stringCat =
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
    // Placeholder build; the Future is created and will be consumed in the
    // next small commit where we add the FutureBuilder UI.
    return Scaffold(
      appBar: AppBar(title: Text(categoryTitle(widget.category))),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
