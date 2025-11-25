# Collection Page — Requirements

## Overview
The Collection Page displays products for a single Category (Clothing, Merchandise, Halloween, Signature & Essentials Range, Portsmouth City Collection, Pride Collection, Graduation). The page:

- Is implemented as `lib/collection_page.dart` and is a `StatefulWidget` `CollectionPage({ required Category category })`.
- Loads products from the app JSON via the existing JSON loader (`loadProductData()` in `json_parser.dart`).
- Filters products by category and displays them in a responsive GridView using existing `ProductCard(productID: ...)`.
- Renders the app `Header()` at top and `Footer()` at bottom, and does NOT include the hero bar.
- Uses a `Category` enum to represent categories and a helper to map enum → display string (include emoji for specified categories).
- Creates the Future once in `initState()` and uses `FutureBuilder` to render loading/error/content states.

## 1. Feature description

The Collection Page shows a list of products belonging to a single category. It provides a heading, simple filter/sort controls, a product count, and a responsive grid of `ProductCard` widgets. The page must load data from the app JSON, handle loading/error/empty states, and be robust to small JSON variations.

Key behaviors:
- Accept a `Category` enum as input to determine which products to show.
- Use the app's JSON loader to retrieve products; support both raw `List` and `{ "products": [...] }` shapes.
- Filter products by category (case-insensitive) and display matching items in a responsive grid.

## 2. User stories

- As a shopper, I want a page titled with the collection name so I know what I'm browsing.
- As a shopper, I want to see how many products are in the collection so I know the selection size.
- As a shopper, I want simple filter and sort controls so I can narrow or reorder results.
- As a shopper on mobile and desktop, I want the grid to be responsive so items do not overflow horizontally.
- As a developer, I want the JSON loaded once and errors surfaced so the UI is stable and debuggable.
- As QA, I want `CollectionPage(Category.Graduation)` to include a Graduation Bear placeholder product.

## 3. Acceptance criteria

### A. UI layout and content

- `Header()` is displayed at the top.
- A full-width, large-font category heading is displayed directly below `Header()` (e.g., `Graduation 🎓`).
- Immediately below the heading is a controls row containing:
	- A **FILTER BY** Dropdown (placeholder options: All, Size, Colour).
	- A **SORT BY** Dropdown (placeholder options: Popularity, Price: Low→High, Price: High→Low).
	- A text label showing `"{i} products"` reflecting the number of filtered products.
- The product list is a `GridView` of `ProductCard(productID: ...)`:
	- Grid is responsive: `crossAxisCount` adapts by screen width (suggested: mobile 1–2, tablet 3–4).
	- No horizontal overflow on narrow screens.
- `Footer()` appears at the bottom.

### B. Data & loading behavior

- Data is loaded using a `Future` created once in `initState()` and reused by `FutureBuilder`.
- JSON shape support: handles both raw `List` and `{ "products": [...] }` envelope.
- Filtering is case-insensitive; if JSON lacks category fields, the Graduation Bear (id `grad_bear`) must appear for `Category.Graduation` as a placeholder.
- While loading show a `CircularProgressIndicator`.
- If load fails show a readable error with `snapshot.error`.
- If no products found show a friendly `"No products found"` message and still render `Footer()`.

### C. Robustness & types

- Price parsing handles both `int` and `double` safely (use `double` internally or parse safely).
- Skip or render a minimal card for products missing required fields (id, name).
- Avoid creating the JSON `Future` inside `build()`.

## 4. Data model & enum

- Add enum (example names):

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
```

- Add a helper to return display string (including emoji where specified).
- Expected JSON example:

```json
{ "products": [ { "id":"grad_bear", "name":"Graduation Bear", "price":15, "category":"Graduation" } ] }
```

## 5. Implementation subtasks

**Subtask A — Enum & helpers**
- Create `Category` enum and `String categoryTitle(Category)` helper.
- Add `Category` → canonical category string mapping for JSON comparison.

**Subtask B — Data loader helper**
- Implement `_loadProductsForCategory(Category)`:
	- Call `loadProductData()`.
	- Normalize shape to get product list.
	- Parse items into `ProductModel` or a minimal product object.
	- Filter by category (case-insensitive).
	- Return `List<ProductModel>`.

**Subtask C — CollectionPage widget**
- Create `CollectionPage extends StatefulWidget` with `final Category category`.
- In State, define `late final Future<List<ProductModel>> _futureProducts;` and set in `initState()`.
- Use `FutureBuilder` in `build()` to render loading/error/content.

**Subtask D — Controls row & interactions**
- Implement `FILTER BY` and `SORT BY` `DropdownButton`s (initially placeholders).
- Display product count dynamically from the loaded list.

**Subtask E — Grid UI**
- Use `GridView.builder` with a suitable `SliverGridDelegate` or `GridView.count` with responsive `crossAxisCount`.
- Each child: `ProductCard(productID: product.id)`.

**Subtask F — Edge cases & error handling**
- Handle missing fields and numeric type variations.
- If loader throws, surface `snapshot.error` in UI.

**Subtask G — Integration & navigation**
- Document how to navigate to the page:

```dart
Navigator.push(context, MaterialPageRoute(builder: (_) => CollectionPage(category: Category.Graduation)));
```

**Subtask H — Testing & verification**
- Manual verification steps and optional unit tests for parsing logic.

## 6. Acceptance test checklist (QA)

- [ ] Header renders.
- [ ] Category heading matches enum→display mapping and occupies a full row.
- [ ] Controls row contains FILTER BY, SORT BY and product count.
- [ ] Loading state shows spinner.
- [ ] Error state shows readable message.
- [ ] For `Category.Graduation`, the Graduation Bear appears in the GridView.
- [ ] Grid layout is responsive (no horizontal overflow).
- [ ] Footer renders.
- [ ] No runtime type errors when parsing price values.

## 7. Notes & constraints

- Keep `ProductModel` unchanged unless necessary; if updating model types (e.g., `price` → `double`) note the change and parse backward‑compatibly.
- Use Graduation Bear (`grad_bear`) as placeholder if category fields missing.
- Avoid long-running synchronous IO in `initState()` — use an async loader and `FutureBuilder`.

---
~