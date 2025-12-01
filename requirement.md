
**Goal**: Replace the two unused `ProductDropdown()` widgets at the top of `lib/collection_page.dart` with a single, reusable `FilterDropdown` component that supports category filtering and product sorting. Both filters must be combinable and must emit the resulting product list back to the page UI.

**Files to change / reference**:
- `lib/collection_page.dart` — replace the two `ProductDropdown()` instances and wire UI/state to use `FilterDropdown`.
- `lib/models/category.dart` (or `lib/category.dart`) — provide enum values used for the category filter.
- `assets/products.json` — product entries may contain multiple category values; parsing rules are described below.
- `lib/main.dart` — `DetailDropdown()` is an optional alternate base class; explain chosen base in a short comment.

**Component API**
- **Class**: `FilterDropdown` — recommended to inherit from `ProductDropdown` (or `DetailDropdown` with justification).
- **Constructor**:
	- `FilterDropdown({required List<Product> products, required ValueChanged<List<Product>> onChanged, Category? initialCategory, SortOption? initialSort})`
	- `products`: master list to filter/sort (component should not own source data).
	- `onChanged`: invoked whenever the filtered/sorted list changes; receives the new list.
	- `initialCategory`: `null` means "All Products".
	- `initialSort`: default sort option (can be `null` to mean leave current order).

**UI**
- Display two labeled dropdowns side-by-side or stacked as space permits:
	- **Label**: `Filter` — options: `All Products` plus every value from the `Category` enum.
	- **Label**: `Sort By` — options described in Sort Options below.
- `FilterDropdown` should be stateless where possible; it may hold minimal UI selection state but must call `onChanged` to pass new results.

**Filter (Category)**
- Default label: `Filter` and default selected value: `All Products`.
- Option set: `All Products` + all `Category` enum values from `category.dart`.
- Behavior: a product entry whose `categories` array contains any matching enum value must be included when that category is selected.
- If `All Products` is selected, no category filtering is applied.

**Sort Options**
- Label: `Sort By`. Default: leave list in original order unless `initialSort` is provided.
- Options (suggested enum `SortOption`):
	- `AlphabeticalAsc` — Alphabetical A–Z by `product.name` ascending.
	- `AlphabeticalDesc` — Alphabetical Z–A by `product.name` descending.
	- `PriceLowHigh` — Price low → high using numeric `salePrice` if > 0, otherwise use `price` (see parsing rules).
	- `PriceHighLow` — Price high → low using numeric `salePrice` if > 0, otherwise `price`.
- Behavior: apply sort after category filtering. Sorting must be stable and deterministic.

**Price parsing rules**
- Products in `assets/products.json` may store prices as numbers or numeric strings. Convert to numeric values safely before sorting.
- When a `salePrice` exists and is greater than 0, prefer `salePrice` for sorting; otherwise fall back to `price`.

**Combined behavior**
- Apply category filter first, then sort the filtered list.
- After applying both operations, call `onChanged(filteredAndSortedProducts)` so `collection_page.dart` can update the displayed grid/list.

**Edge cases & robustness**
- Empty `products` input: return an empty list and call `onChanged([])`.
- Products with multiple categories: include product when any listed category matches the selected category.
- Ensure stable sort ordering when keys are equal (e.g., fallback to product name or original index for determinism).
- Parsing failures (non-numeric price fields): treat as price `0` for sorting purposes and do not crash.

**Acceptance criteria**
- `collection_page.dart` displays a single `FilterDropdown` area containing labeled `Filter` and `Sort By` dropdowns.
- Selecting a category restricts displayed products to those whose `categories` array contains that category.
- Selecting a sort order sorts the currently visible (category-filtered) products according to the selected option.
- Category and sort selections can be combined: selecting both updates the grid immediately with category-filtered, sorted results.
- No unused `ProductDropdown()` widgets remain in `collection_page.dart`.

**Implementation notes & suggestions**
- Prefer keeping `FilterDropdown` UI-state minimal; the master list should live in `collection_page.dart` and be passed into the component.
- If choosing a base class, either extend `ProductDropdown` for feature parity or `DetailDropdown` if it already provides the desired dropdown styling — add a brief comment explaining the choice.
- Keep the `onChanged` contract simple: always return a `List<Product>` representing the current view after filter+sort.

**Testing**
- Manual test: select each category and each sort option; verify results match expectations.
- Unit tests should cover:
	- Empty `products` -> empty result.
	- Products with multiple categories -> included when any category matches.
	- Sorting with `salePrice` > 0 preferred over `price`.
	- Stable ordering when keys are equal.

**Files touched (expected)**
- `lib/collection_page.dart` (replace dropdowns + wire callbacks)
- `lib/filters/filter_dropdown.dart` (new component file) — optional: place alongside other widgets.
- `lib/models/category.dart` (use existing enum or add missing values)
- `assets/products.json` (no change required, but tests/readme may reference example entries)

If anything in this spec should be more or less prescriptive, tell me which area to adjust (API, default sort behavior, or where the component class should live). 
