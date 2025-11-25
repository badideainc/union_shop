Cart feature — Requirements
1. Feature description & purpose
Add a minimal shared cart so users can add products from a Product Page and view the cart on a Cart Screen accessible from the app Header. The implementation must be minimal and safe: introduce a ChangeNotifier-based CartModel, wire it into app scope, call it when the user taps Add to Cart, and allow CartScreen to load/display cart contents. Do not modify unrelated code or add new helper files.

Scope

Minimal changes only to:
cart_model.dart
product_page.dart
cart_screen.dart
main.dart
Use Provider / ChangeNotifier to expose the cart to the app (or document adding provider to pubspec as a separate small commit).
Do not add helper functions or files beyond the four files above.
Non-goals

No checkout/ordering flow.
No persistence beyond in-memory runtime cart.
No UI redesign beyond adding the add-to-cart hook and the CartScreen load UI and Header navigation hook.
2. User stories
Shopper — Add to cart:
As a shopper, when I view a product I want to add it to my basket by tapping Add to Cart so I can collect items for checkout later.
Shopper — View cart:
As a shopper, I want to view the items I added in a Cart screen so I can review names, quantities and total price.
Shopper — Access cart globally:
As a shopper, I want the cart reachable from any page via the Header button so I can inspect my basket at any time.
Developer — Minimal, testable change:
As a developer, I want the CartModel to extend ChangeNotifier and be provided at app root so UI updates automatically via Provider.watch and changes are isolated to small commits.
3. Acceptance criteria
Functional

CartModel
Extends ChangeNotifier.
Exposes a public items getter (List of cart items or ProductModel references).
add(ProductModel product) increases quantity for existing item or adds as new, then calls notifyListeners().
remove(String productId) removes item and calls notifyListeners().
totalPrice getter returns sum as double.
product_page.dart
On Add to Cart tap, code calls the cart API (context.read<CartModel>().add(...)) with the current product.
No other UI structure or behavior changed.
cart_screen.dart
Reads the cart with context.watch<CartModel>() and displays the list of items (name, price, qty) and totalPrice.
Only loading/display implemented — no checkout.
main.dart
App is wrapped with ChangeNotifierProvider(create: (_) => CartModel(), child: MaterialApp(...)).
If provider dependency missing, add provider: ^6.0.0 to pubspec.yaml as a separate small commit.
Header navigation
Header has a button (existing header button) that pushes/navigates to CartScreen; only navigation hook is implemented.
Behaviour & robustness

Adding the same ProductModel twice increments item quantity (not duplicate entries).
Price stored as double; formatting to two decimals is handled in views (not part of CartModel).
CartModel.notifyListeners() invoked on add/remove so UI updates automatically.
Quality

Changes limited to the specified files and each change is a small, reviewable commit.
No new helper files or unrelated code improvements.
Unit tests or manual test instructions provided as small commit if requested.
4. Subtasks (small committable steps)
Each subtask should be implemented as a single small commit that can be reviewed independently.

Subtask A — Add CartModel (small commit)

What: Create/modify cart_model.dart to define CartModel extends ChangeNotifier.
API:
List<CartItem> get items
void add(ProductModel product)
void remove(String productId)
double get totalPrice
File(s): cart_model.dart
Success criteria: CartModel compiles and exposes API and notifyListeners() on mutations.
Subtask B — Wire Provider at app root (small commit)

What: Wrap MaterialApp with ChangeNotifierProvider in lib/main.dart.
If provider is missing, add provider: ^6.0.0 to pubspec.yaml as its own commit (documented).
File(s): main.dart (and optional pubspec.yaml)
Success criteria: Provider is available via context in app widgets.
Subtask C — Add-to-cart hook on ProductPage (small commit)

What: In product_page.dart add a single call in the Add to Cart button handler:
context.read<CartModel>().add(currentProduct);
Do not change UI layout or other logic.
File(s): product_page.dart
Success criteria: Tapping Add to Cart calls CartModel.add (no other changes).
Subtask D — CartScreen loading/display (small commit)

What: Implement cart display using context.watch<CartModel>() in lib/views/cart_screen.dart.
Show list items: name, unit price, quantity and subtotal.
Show totalPrice at bottom.
Loading is instantaneous (in-memory); no async functions.
File(s): cart_screen.dart
Success criteria: CartScreen compiles, shows cart items and total, and updates when items added/removed.
Subtask E — Header button navigation (small commit)

What: Hook existing Header() button to navigate to CartScreen (Navigator.push or pushNamed).
Only implement the navigation call; no Header redesign.
File(s): wherever Header is implemented/imported (likely lib/main.dart/header import or product_page.dart usage) — if Header is in main.dart import and edit there.
Success criteria: Tapping header cart button opens CartScreen.
Subtask F — Small manual test and notes commit

What: Add a short README note or PR description describing manual test steps and that provider was added (if applicable).
File(s): project root – small text/commit.
Success criteria: Reviewer can follow steps to verify acceptance criteria manually.
Optional Subtask G — Unit test (separate small commit)

What: Add a simple unit test for CartModel.add/remove/totalPrice in test/cart_model_test.dart.
File(s): test/cart_model_test.dart
Success criteria: Tests pass locally.
5. Manual test steps (short)
Start app (flutter run).
Open a product page for example product.
Tap Add to Cart once → navigate to Header → press Cart button → confirm item visible and total equals price.
Tap Add to Cart again → confirm quantity increment and total updates.
Remove item from CartScreen → confirm UI updates and list is empty.
6. Implementation constraints / rules to enforce in commits
Only modify files listed in subtasks.
Keep commits single-purpose and small.
Do not add helper files or global singletons—use Provider.
Keep ProductModel usage as-is; CartModel may store ProductModel references or a small struct, but avoid modifying ProductModel.