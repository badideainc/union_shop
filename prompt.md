Goal
Replace the two unused ProductDropdown() widgets at the top of c:\Users\blair\Documents\University Programming\flutter\union_shop\lib\collection_page.dart with a single, reusable FilterDropdown component that supports category filtering and product sorting. Both filters must be combinable.

Files to change / reference
- collection_page.dart (replace the two ProductDropdown() instances and wire UI/state)
- category.dart (provide enum values for the category filter)
- products.json (product entries may contain multiple categories)
- main.dart (DetailDropdown() is an alternate base class if preferred)

Requirements
1. New component
   - Create a new class FilterDropdown that inherits from ProductDropdown (or optionally from DetailDropdown in main.dart).
   - Make FilterDropdown reusable and stateless where possible; expose callbacks to update the collection_page state.

2. Filter 1 — "Filter"
   - Label: "Filter" (default: "All Products")
   - Options: All enum values from category.dart plus an "All Products" option.
   - Behavior: products.json entries may have multiple categories; when a category is selected, include any product whose categories list contains the selected enum value.
   - If "All Products" is selected, do not filter by category.

3. Filter 2 — "Sort By"
   - Label: "Sort By" (default: leave current order or specify explicit default)
   - Options:
     - Alphabetical A-Z (by product.name ascending)
     - Alphabetical Z-A (by product.name descending)
     - Price Low-High (by numeric price/salePrice ascending)
     - Price High-Low (by numeric price/salePrice descending)
	 - If salePrice is not greater than 0 ignore it
   - Behavior: sort the (already category-filtered) product list accordingly.

4. Combined behavior
   - Both filters must be applicable at the same time: first apply the category filter, then apply the sort to the filtered list.
   - The component should emit the resulting product list (or trigger a callback) so collection_page.dart can update the displayed grid/list.

5. API & integration suggestions (example)
   - FilterDropdown constructor suggestions:
     - FilterDropdown({
         required List<Product> products,
         required ValueChanged<List<Product>> onChanged,
         Category? initialCategory, // null means All Products
         SortOption? initialSort
       })
   - onChanged should be invoked whenever filter or sort changes with the new list.
   - Keep UI state minimal in FilterDropdown; let collection_page.dart hold the master list.

6. Edge cases & tests
   - Empty product list: handle gracefully and return empty list.
   - Products with multiple categories: include if any category matches.
   - Stable sort where possible (so sorting after filtering is deterministic).
   - Correctly parse numeric prices if stored as strings in products.json.

Acceptance criteria
- collection_page.dart shows one FilterDropdown area with two labeled dropdowns: "Filter" and "Sort By".
- Selecting a category restricts products to those that have that category in their categories array.
- Selecting a sort order sorts the currently visible products.
- Both changes update the visible products immediately and can be combined.
- No unused ProductDropdown() widgets remain.

If you prefer, implement FilterDropdown by extending DetailDropdown from main.dart instead of ProductDropdown — explain why you chose one base class over the other in a short comment in the code.