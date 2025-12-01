# Union Shop — University of Portsmouth (Coursework)

This repository is a student recreation of the University of Portsmouth Union Shop mobile/web app. It is implemented in Flutter as part of a university coursework module to demonstrate building a small e-commerce-like interface with product browsing, product details, and a simple cart.

**Status:** Educational project — suitable for running locally and for automated widget/unit testing. Not a production system.

**Quick links**
- **App code:** `lib/`
- **Tests:** `test/`
- **Assets:** `assets/`

**Contents**
- **Features:** Browse products by category, view product details, product options, add to cart, basic cart management.
- **Tech:** Flutter, GoRouter, Provider for state management, simple JSON-based product store in `assets/products.json`.

**Why this project exists**
This project was created as part of a university assignment to practice Flutter UI, asynchronous asset loading, widget testing, and small-scale app architecture. It reproduces basic shopping functionality for an educational example.

**Getting started**

Prerequisites
- Install Flutter (stable channel) and ensure `flutter` is on your PATH. See https://flutter.dev/docs/get-started/install
- A supported platform (Windows/macOS/Linux) or use Chrome for web during development.

Clone and install dependencies

```powershell
git clone https://github.com/badideainc/union_shop
cd union_shop
flutter pub get
```

Run the app

```powershell
# Run on an available device (desktop/web/mobile)
flutter run

# Run a single platform, e.g. Windows
flutter run -d windows
```

Run tests

```powershell
# Run all tests
flutter test

# Run a single test file
flutter test test/product_test.dart
```

Important testing notes
- Widget tests that cause real HTTP requests will receive HTTP 400 responses in the test harness. Tests should avoid relying on network requests.
- To make tests deterministic, the project includes testing hooks:
	- `lib/json_parser.dart` exposes `loadProductData({Future<String> Function()? loader})` so tests can inject JSON strings instead of mocking platform channels.
	- `ProductPage` accepts an optional `productFuture` so tests can inject a resolved `ProductModel` and avoid asset loading/network I/O.
	- `ProductCard` and other widgets also accept optional injection points in tests (see `lib/main.dart` changes) to avoid network/asset dependencies.

Test guidance
- Use `tester.pumpAndSettle()` in widget tests to wait for async `FutureBuilder` resolution.
- Use `tester.ensureVisible(finder)` before `tap()` for buttons that might be off-screen.

Project structure (high-level)
- `lib/` — application code (screens, widgets, models)
	- `main.dart` — home screen, navigation, shared widgets
	- `product_page.dart` — product detail screen and supporting widgets
	- `collection_page.dart` — category listing and filtering
	- `json_parser.dart` — load product data from `assets/products.json`
	- `models/` — `product_model.dart`, `cart_model.dart`, `category.dart`, etc.
- `assets/` — product JSON and images
- `test/` — unit + widget tests

Known issues & recommendations
- Network images in widget tests may still cause warnings or require `HttpOverrides` for complex scenarios. Prefer injecting test data or guarding network access in tests.
- Some UI strings or assets are simplified for coursework demonstration.

Acknowledgements
- This project is an educational recreation of the University of Portsmouth Union Shop UI for coursework.

License
- This repository does not include a license by default. If you plan to publish or share, add a LICENSE file (e.g., MIT) as appropriate.