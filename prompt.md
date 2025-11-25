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