Goal
Implement collection_page.dart for the Union Shop Flutter app. The page shows products for a single category loaded from the app JSON. Focus on correctness, robustness and matching the app's existing style components (Header(), Footer(), ProductCard()).

Files available / expectations
- Use existing app widgets: Header(), Footer(), ProductCard(id).
- Data loader: use json_parse.dart (or json_parser.dart) function loadProductData() which returns raw JSON from assets. QThe JSON has top-level {"products": [...]}, account for that.
- Use the existing ProductModel class to represent a product. Price is a double.
- Do NOT include the hero bar.

Requirements
1) Enum
- Add a Category enum with members:
  - Clothing
  - Merchandise
  - Halloween
  - SignatureAndEssentials (or SignatureAndEssentialsRange)
  - PortsmouthCityCollection
  - PrideCollection
  - Graduation

- Provide a mapping helper to return the display title string (and emoji where specified) for each enum member.

2) Widget API
- Implement a StatefulWidget (CollectionPage) that accepts:
  - final Category category;
  - optional args for initial filter/sort (can be omitted).

3) Page layout (top-to-bottom)
- Header() (existing widget) must be at top.
- Immediately under Header(), a full-width category heading row:
  - The heading uses the app's heading style (large font) and takes one full row.
- Under heading, a controls row containing:
  - "FILTER BY" Dropdown (placeholder options: All, Size, Colour)
  - "SORT BY" Dropdown (placeholder options: Popularity, Price: Low→High, Price: High→Low)
  - "{i} products" text showing number of products in that category
  - Controls should be horizontally aligned, responsive (wrap on narrow screens).
- Main content: GridView showing ProductCard widgets for each product in the selected category.
  - Use responsive grid: e.g. GridView.count with crossAxisCount depending on screen width (mobile 1-2, tablet 3-4).
  - Each grid child is ProductCard(productId: product.id) depending on your app API.
- Footer() at bottom.

4) Data loading
- Load all products from JSON using the app json loader.
- Extract the array of product objects (handle both raw List and {"products": List}).
- Filter by category: product JSON must have a category field
- Use async loading in initState; create the Future once and use FutureBuilder to build the page.
- Avoid creating the Future inside build() to prevent repeated loads.

5) Robustness & types
- Price will be double
- If a product is missing id or name, skip it or show a minimal card.
- Show loading indicator while fetching.
- Show friendly error or "No products found" UI if empty/error.

6) Implementation notes for the LLM
- Use a private helper method to map Category -> display string.
- Use ProductModel.productFromJson (or alternative loader) if available; otherwise convert raw map to ProductModel safely.
- Use MediaQuery or LayoutBuilder to set crossAxisCount responsively.
- Keep code consistent with the app: use Padding, SizedBox, TextStyles already in use (heading style).

7) Example snippets to include in the implementation
- Category enum:
```dart
enum Category {
  Clothing,
  Merchandise,
  Halloween,
  SignatureAndEssentialsRange,
  PortsmouthCityCollection,
  PrideCollection,
  Graduation,
}

String categoryTitle(Category c) {
  switch (c) {
    case Category.Clothing: return 'Clothing';
    case Category.Merchandise: return 'Merchandise';
    case Category.Halloween: return 'Halloween 🎃';
    case Category.SignatureAndEssentialsRange: return 'Signature and Essentials Range';
    case Category.PortsmouthCityCollection: return 'Portsmouth City Collection';
    case Category.PrideCollection: return 'Pride Collection 🏳️‍🌈';
    case Category.Graduation: return 'Graduation 🎓';
  }
}
```

- Example JSON (use Graduation Bear as placeholder if categories missing):
```json
{
  "products": [
    { "id": "grad_bear", "name": "Graduation Bear", "price": 15, "category": "Graduation" },
    ...
  ]
}
```

- Data load & FutureBuilder pattern:
```dart
late final Future<List<ProductModel>> _futureProducts;

@override
void initState() {
  super.initState();
  _futureProducts = _loadProductsForCategory(widget.category);
}

Future<List<ProductModel>> _loadProductsForCategory(Category cat) async {
  final raw = await loadProductData(); // from json_parse.dart
  final List items = raw is Map ? (raw['products'] ?? []) : (raw is List ? raw : []);
  final products = <ProductModel>[];
  for (final dynamic item in items) {
    if (item is Map) {
      // parse product; handle price as num
      final p = parseProductModel(item);
      if (p != null) {
        if (matchesCategory(p, cat)) products.add(p);
      }
    }
  }
  return products;
}
```

Acceptance criteria
- Running CollectionPage(Category.Graduation) displays a heading "Graduation 🎓" under Header(), the filter/sort/count row, a GridView with at least the Graduation Bear ProductCard, and Footer() at bottom.
- Loading shows a CircularProgressIndicator; errors show a readable message.
- No Future is re-created on every build; FutureBuilder uses the stored Future.
- Grid is responsive and avoids horizontal overflow.

Deliverable request
- Provide full content of lib/collection_page.dart implementing above.
- Include any small helper functions you create.
- If changes to ProductModel or json parser are required, explain them briefly and show minimal safe code.

End prompt
~