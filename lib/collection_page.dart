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
  List<ProductModel>? _filteredProducts;

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

                      final displayList = _filteredProducts ?? snapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Controls row: replaced two ProductDropdown widgets
                          // with a single FilterDropdown that emits the
                          // filtered+sorted list via `onChanged`.
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: FilterDropdown(
                                  products: snapshot.data ?? [],
                                  onChanged: (list) {
                                    setState(() {
                                      _filteredProducts = list;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text('${displayList.length} products'),
                            ],
                          ),

                          const SizedBox(height: 24),

                          if (displayList.isEmpty) ...[
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
                              children: displayList
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
  List<ProductModel> _filtered = [];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _selectedSort = widget.initialSort;
    // Emit initial results once after first frame so parent can receive initial list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _emit();
    });
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
                onChanged: (v) {
                  setState(() {
                    _selectedCategory = v;
                  });
                  _emit();
                },
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
                onChanged: (v) {
                  setState(() {
                    _selectedSort = v;
                  });
                  _emit();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<ProductModel> _applyFilter() {
    if (_selectedCategory == null) {
      return List<ProductModel>.from(widget.products);
    }
    return widget.products.where((p) {
      final cats = p.category;
      if (cats == null || cats.isEmpty) return false;
      return cats.contains(_selectedCategory);
    }).toList();
  }

  List<ProductModel> _applySort(List<ProductModel> list) {
    if (_selectedSort == null) return list;
    final originalIndex = {for (var i = 0; i < list.length; i++) list[i].id: i};
    list.sort((a, b) {
      int cmp = 0;
      switch (_selectedSort!) {
        case SortOption.alphabeticalAsc:
          cmp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
        case SortOption.alphabeticalDesc:
          cmp = b.name.toLowerCase().compareTo(a.name.toLowerCase());
          break;
        case SortOption.priceLowHigh:
          final pa = (a.salePrice > 0) ? a.salePrice : a.price;
          final pb = (b.salePrice > 0) ? b.salePrice : b.price;
          cmp = pa.compareTo(pb);
          break;
        case SortOption.priceHighLow:
          final pa = (a.salePrice > 0) ? a.salePrice : a.price;
          final pb = (b.salePrice > 0) ? b.salePrice : b.price;
          cmp = pb.compareTo(pa);
          break;
      }
      if (cmp != 0) return cmp;
      final ia = originalIndex[a.id] ?? 0;
      final ib = originalIndex[b.id] ?? 0;
      if (ia != ib) return ia.compareTo(ib);
      return a.id.compareTo(b.id);
    });
    return list;
  }

  void _emit() {
    final results = _applySort(_applyFilter());
    if (!mounted) return;
    setState(() => _filtered = results);
    try {
      widget.onChanged(results);
    } catch (_) {
      // Guard: if parent handler throws, we don't crash the widget.
    }
  }
}
