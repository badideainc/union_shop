import 'package:flutter/material.dart';
import 'package:union_shop/json_parser.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/models/category.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/main.dart';

// Sort options used by the FilterDropdown component.
// Kept at top so later in-file FilterDropdown can reference it.
enum SortOption {
  alphabeticalAsc,
  alphabeticalDesc,
  priceLowHigh,
  priceHighLow
}

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
                  if (widget.category == ProductCategory.sale) ...[
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        """

Don’t miss out! Get yours before they’re all gone!

 

All prices shown are inclusive of the discount 🛒
""",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
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

// --- FilterDropdown (skeleton, step 2) --------------------------------------
class FilterDropdown extends StatefulWidget {
  final List<ProductModel> products;
  final ValueChanged<List<ProductModel>> onChanged;
  final ProductCategory? initialCategory;
  final SortOption? initialSort;

  const FilterDropdown({
    super.key,
    required this.products,
    required this.onChanged,
    this.initialCategory,
    this.initialSort,
  });

  @override
  State<FilterDropdown> createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<FilterDropdown> {
  ProductCategory? _selectedCategory;
  SortOption? _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _selectedSort = widget.initialSort;
  }

  @override
  Widget build(BuildContext context) {
    // Generate category dropdown items (small step).
    final categoryOptions = <DropdownMenuItem<ProductCategory?>>[];
    categoryOptions.add(const DropdownMenuItem<ProductCategory?>(
      value: null,
      child: Text('All Products'),
    ));
    for (final c in ProductCategory.values) {
      categoryOptions.add(DropdownMenuItem<ProductCategory?>(
        value: c,
        child: Text(categoryTitle(c)),
      ));
    }

    // Generate sort dropdown items (small step).
    final sortOptions = <DropdownMenuItem<SortOption?>>[
      const DropdownMenuItem(value: null, child: Text('Default')),
      const DropdownMenuItem(
          value: SortOption.alphabeticalAsc, child: Text('Alphabetical A-Z')),
      const DropdownMenuItem(
          value: SortOption.alphabeticalDesc, child: Text('Alphabetical Z-A')),
      const DropdownMenuItem(
          value: SortOption.priceLowHigh, child: Text('Price Low-High')),
      const DropdownMenuItem(
          value: SortOption.priceHighLow, child: Text('Price High-Low')),
    ];

    // Basic UI: two labeled dropdowns using pre-built option lists.
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Filter'),
              DropdownButton<ProductCategory?>(
                isExpanded: true,
                value: _selectedCategory,
                items: categoryOptions,
                onChanged: (v) => setState(() => _selectedCategory = v),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sort By'),
              DropdownButton<SortOption?>(
                isExpanded: true,
                value: _selectedSort,
                items: sortOptions,
                onChanged: (v) => setState(() => _selectedSort = v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
