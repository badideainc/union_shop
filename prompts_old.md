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
Goal
Implement a minimal cart system for the Union Shop Flutter app. Make the smallest, safest changes required so the app can add products to a shared cart and load that cart on the Cart screen. Do not change unrelated code or add helper functions.

Files you will modify (only these)
- lib/models/cart_model.dart — implement CartModel (must extend ChangeNotifier)
- lib/product_page.dart — call into CartModel when user adds a product to cart
- lib/views/cart_screen.dart — read/load the cart for display (only implement loading/display; do not change navigation)
- lib/main.dart — wrap the app with a provider if necessary (ChangeNotifierProvider). Make this the minimal change required.

Additional UI requirement
- CartScreen must be accessible from any page via a button in the app Header() found in #main.dart. Navigation already exists but may need to be edited to account for new changes

Constraints (must follow)
1. CartModel must extend ChangeNotifier.
2. Do not modify unrelated files or improve unrelated code.
3. Do not add new helper files or folders.
4. Do not implement any helper functions beyond what’s needed for CartModel and the three files above.
5. Make each change as a small commit-sized patch and describe each change in one sentence.

Functional requirements
- CartModel API (minimal):
  - public getter items: List<ProductModels> (or similar)
  - add(ProductModel product) — add a product (or id + qty) and notifyListeners()
  - remove(String productId) — remove an item and notifyListeners()
  - double get totalPrice
  - Keep implementation simple; storing id, name, price and quantity is acceptable.
- product_page.dart:
  - When the user taps Add to Cart, call the CartModel API to add that product via Provider (context.read<CartModel>().add(...)) or a singleton only if provider cannot be added.
  - Do not change UI structure beyond adding the hook for add-to-cart.
- cart_screen.dart:
  - Read the CartModel (context.watch<CartModel>()) and implement the loading/display of cart items (list of item names and prices). Do not implement checkout features.
- main.dart:
  - Add minimal provider wiring: wrap MaterialApp with ChangeNotifierProvider(create: (_) => CartModel(), child: MaterialApp(...))
  - If provider is not already listed in pubspec.yaml, include adding provider: ^6.0.0 as a separate small commit.

Acceptance criteria (tests / manual)
- After adding an item on ProductPage, the CartModel contains that item and its quantity reflects additions.
- Navigating to CartScreen displays the cart items (name and price) and totalPrice.
- CartModel.notifyListeners() is called on add/remove so UI updates.
- CartScreen is reachable from any page via the Header button.
- No other unrelated files are changed.
- All changes are in small, reviewable commits (one commit per file change suggested above).

Deliverables (what the LLM should return)
- For each small commit (in order):
  1. A one-sentence explanation of the change.
  2. The exact patch (file path + code) to apply. Use minimal edits.
  3. Any pubspec change if provider is added.
- Do not add any extra features beyond the above.

Edge cases / Notes
- Price may be int/double; store price as double and format elsewhere.
- If ProductModel already contains id/name/price, CartModel may store ProductModel references or a small DTO.
- If adding the provider dependency, ensure tests still run (mention asset mocking if needed).

End.
~
Goal
Add two small interactive controls to each cart item row in CartWidget on the Cart screen:
1) a "remove" TextButton that removes the product from the cart and the UI row, and
2) a quantity editor: a "Quantity" label, a TextField (hint = current quantity) and an "Update" button using ImportButtonStyle() that updates the ProductModel.quantity.

Constraints / non‑goals
- Change only the CartWidget code in lib/views/cart_screen.dart (or the widget file that renders each cart item) and any direct calls required to update ProductModel or CartModel already in the project.
- Do NOT change unrelated files or add helper files/functions.
- Respect existing state management (use the existing CartModel / ProductModel API). If the project uses Provider, use context.read / context.watch only; do not introduce a new state system.
- Keep commits small: one focused change implementing these controls (UI + handlers) in this file.

Files to modify
- lib/views/cart_screen.dart (the CartWidget / cart item row rendering)

UI requirements (exact)
- For each cart item row, below the existing product info, add a single horizontal Row with three elements:
  - TextButton("remove")
    - onPressed: remove the product from the cart (call CartModel API or update ProductModel.quantity to zero and notify listeners) and remove the row from the UI.
    - Use descriptive semantics for accessibility (tooltip/semantics label optional).
  - SizedBox(width: 12)
  - Row (inline) containing:
    - Text("Quantity")
    - SizedBox(width: 8)
    - TextField
      - keyboardType: TextInputType.number
      - controller: a short-lived TextEditingController prefilled with empty but with hintText set to current quantity (e.g. hintText: product.quantity.toString()).
      - input formatting: allow only digits (you may use a simple onChanged parsing). Do not add complex validators.
    - SizedBox(width: 8)
    - ElevatedButton (or Widget that uses ImportButtonStyle())
      - child: Text("Update")
      - style: use ImportButtonStyle() exactly as available (do not invent a new style).
      - onPressed: parse the value entered (int), if valid call the ProductModel quantity setter or CartModel API to update quantity and then call notifyListeners() (or the existing update method).
- Keep layout responsive: the controls row can wrap on small screens. Use Flexible/Expanded for the TextField as needed.

Behaviour requirements (exact)
- Remove action:
  - When remove is tapped, remove that product from the CartModel (or set its quantity to zero and call CartModel.notifyListeners()).
  - The UI should update so the removed item row no longer displays.
- Update action:
  - Parse the number from the TextField; if parse fails, do nothing or optionally show a minimal inline error (not required).
  - On successful parse, set product.quantity = parsedValue (or call CartModel.updateQuantity(productId, parsedValue) if such API exists), then notify listeners so UI updates.
  - If the parsed quantity is less than or equal to 0, remove the product from the cart (i.e., call the same removal behavior as the "remove" button) and ensure the UI row disappears.
  - Do not create new helper functions; call existing model methods or mutate existing ProductModel as your project already does.
- Do not implement persistence or backend calls—this is in-memory cart only.

Edge cases & robustness
- If product.quantity is null or unavailable, default hint to "1".
- Do not clamp values unless a clamp exists in the current ProductModel; if clamp is not present, accept any integer (follow your project’s existing rules).
- Protect against null controllers: create/destroy local TextEditingController in the item widget lifecycle (dispose when appropriate).
- Keep operations synchronous and quick; call notifyListeners() after updates.

Acceptance criteria (tests/manual)
- For a sample cart item, the cart row now shows the new controls under the existing info.
- Pressing "remove" immediately removes the item from CartModel and the row disappears.
- Entering a numeric value in the TextField and pressing "Update" changes the product quantity in ProductModel / CartModel and UI updates to reflect the new quantity and recalculated totals.
- Entering a value <= 0 and pressing "Update" removes the item from the cart and the row disappears.
- No unrelated files were modified.
- The Update button uses ImportButtonStyle() exactly as present in the project.

Deliverable requested from LLM
- A single small commit patch (one file: lib/views/cart_screen.dart) that:
  1. Adds the controls to each cart item row as described.
  2. Hooks "remove" to the existing CartModel/ProductModel remove/decrease behavior.
  3. Hooks "Update" to set the ProductModel quantity and call notifyListeners() (or call CartModel API), and removes the item when the entered quantity is <= 0.
- Include a one-sentence explanation of the change and the exact diff/patch to apply.

Notes for implementer
- If the cart item is rendered by a separate subwidget (e.g., CartItemWidget), modify that widget. If rows are built inline, add the controls inside the map/list builder.
- Use context.read<CartModel>() or direct ProductModel mutation depending on existing code pattern; keep consistent with the codebase.
- Follow project style: padding, spacing and font style should reuse existing widgets where possible.

End.
~
Goal
----
Improve the app navigation by replacing the current static menu behavior with a compact, accessible dropdown anchored to the `Icons.menu` button and enabling nested, navigable dropdowns.

Background
----------
Currently the app shows top-level navigation via `NavButton()` and `NavDropdown()` in `NavBar()` (in `lib/main.dart`). The request is to make the menu more compact (hamburger-triggered) while keeping all existing navigation items and enabling nested dropdown navigation where a dropdown entry can open a new set of options and provide an explicit "back" item.

Requirements
------------
1. Hamburger menu
	- Replace the existing `Icons.menu` behaviour so that tapping the hamburger opens a dropdown menu (or popover) containing the same items that currently appear as `NavButton()` and top-level `NavDropdown()` entries.

2. Reusable `ProductDropdown` / `NavDropdown` behaviour (nested navigation)
	- Modify `NavDropdown()` (or the shared dropdown widget) so that selecting a dropdown item can either:
	  a) navigate directly to a route (existing behaviour), or
	  b) replace the current dropdown content with a new set of options (nested submenu).
	- When a nested submenu is opened, the dropdown should show a first item that navigates back to the previous menu. The back item should display the previous menu heading text prefixed with a left angle bracket, e.g. "< Category" or "< Back to Products".

3. API & Component contract
	- `NavBar()` / `NavDropdown()` should accept an expressive data model that supports both leaf items and nested groups. Example idea:
	  - class MenuItem { final String label; final String? route; final List<MenuItem>? children; }
	- If `children` is present, selecting that item opens a nested menu instead of navigating.
	- Provide an optional callback `onNavigate(String route)` and `onOpenMenu()` / `onCloseMenu()` hooks.

4. Visual & UX details
	- The hamburger dropdown should be visually aligned with the app header and match existing styling (colors, padding, font-size) used by `NavButton()`.
	- When opening a nested submenu, animate the change (slide right) so the transition is obvious.
	- Provide a clear back item as the first row in a nested view with the exact text `"< {heading}"` where `{heading}` is the parent menu title.

5. Accessibility
	- Ensure all dropdown/menu elements are focusable and announce their role to screen readers.
	- The back item must be properly labeled for screen readers.

Acceptance criteria
-------------------
- Tapping `Icons.menu` opens a dropdown with the same set of items currently available via `NavButton()` and `NavDropdown()`.
- Selecting an item with `children` replaces the dropdown content with the child list and shows a first-row "< {heading}" back item.
- Pressing the back item returns to the previous dropdown content.
- Choosing a leaf item (no children) navigates to the intended route and closes the dropdown.
- The implementation exposes a simple data model for menu definition and hooks for navigation events.

Implementation notes / suggestions
-------------------------------
- Implement a small `MenuModel` (list of `MenuItem`) and build the dropdown UI from this data structure.
- For nested views, maintain a stack of `MenuItem` lists in state (push child list on open, pop on back).
- Reuse the existing `NavButton()` styles for menu rows to keep consistent visuals.
- Keep the dropdown widget generic so it can be used in other screens (collection page, product page) if needed.
~