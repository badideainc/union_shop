import 'package:flutter/material.dart';

import 'package:union_shop/product_page.dart';
import 'package:union_shop/about_page.dart';
import 'package:union_shop/print_shack/print_about_page.dart';
import 'package:union_shop/print_shack/print_personal_page.dart';
import 'package:union_shop/collection_page.dart';
import 'package:union_shop/models/category.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/views/cart_screen.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/account_page.dart';

import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/widgets/nav_menu.dart';
import 'package:union_shop/models/menu_item.dart';

void main() {
  runApp(const UnionShopApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final uri = state.uri;
        final id = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
        return ProductPage(productID: id);
      },
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutPage(),
    ),
    GoRoute(
      path: '/personalisation',
      builder: (context, state) => const PrintAboutPage(),
    ),
    GoRoute(
      path: '/personalise-text',
      builder: (context, state) => const PrintPersonalisationPage(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) => const AccountPage(),
    ),
    // Category route - must come after more specific routes
    GoRoute(
      path: '/:category',
      builder: (context, state) {
        final uri = state.uri;
        final catSeg =
            uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
        final cat = pathToCategory(catSeg) ?? ProductCategory.clothing;
        return CollectionPage(category: cat);
      },
    ),
  ],
  errorBuilder: (context, state) => HomeScreen(),
);

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: MaterialApp.router(
        title: 'Union Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
        ),
        routerConfig: _router,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final CartModel cart = CartModel();

  HomeScreen({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateToProduct(BuildContext context) {
    Navigator.pushNamed(context, '/product');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            const Header(),

            // Hero Section
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Stack(
                children: [
                  // Background image
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),
                  // Content overlay
                  Positioned(
                    left: 24,
                    right: 24,
                    top: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Placeholder Hero Title',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "This is placeholder text for the hero section.",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: placeholderCallbackForButtons,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4d2963),
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text(
                            'BROWSE PRODUCTS',
                            style: TextStyle(fontSize: 14, letterSpacing: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Products Section
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    const Text(
                      'PRODUCTS SECTION',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 48),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 2 : 1,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 48,
                      children: const [
                        ProductCard(productID: 'city_postcard'),
                        ProductCard(productID: 'city_magnet'),
                        ProductCard(productID: 'city_bookmark'),
                        ProductCard(productID: 'city_notebook'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            const Footer(),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  // final String title;
  // final String price;
  // final String imageUrl;

  final String productID;

  const ProductCard({
    super.key,
    required this.productID,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // final String title;
  // final String price;
  // final String imageUrl;

  late final Future<ProductModel> _product;

  _ProductCardState();

  @override
  void initState() {
    super.initState();
    _product = ProductModel.productFromJson(widget.productID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _product,
      builder: (context, AsyncSnapshot<ProductModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return const Text("Error loading product, please try again");
        }
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/product',
                arguments: widget.productID);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.asset(
                  snapshot.data!.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child:
                            Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    snapshot.data!.name,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  if (snapshot.data!.salePrice >= 0)
                    Row(
                      children: [
                        Text(
                          '£${snapshot.data!.salePrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '£${snapshot.data!.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      '£${snapshot.data!.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class NavButton extends StatelessWidget {
  final String optionName;
  final String url;

  const NavButton({super.key, required this.optionName, required this.url});

  @override
  Widget build(BuildContext context) {
    //return ElevatedButton(onPressed: onPressed, child: Text(optionName));
    return ElevatedButton(
      onPressed: () {
        barNavigateTo(context);
      },
      child: Text(
        optionName,
      ),
    );
  }

  void barNavigateTo(BuildContext context) {
    Navigator.pushNamed(context, url);
  }
}

class NavDropdown extends DetailedDropdown {
  final Map<String, String> pages;
  final Map<String, ProductCategory>? pageCategories;
  const NavDropdown(
      {super.key,
      required this.pages,
      this.pageCategories,
      required super.options,
      required super.optionName});

  void barNavigateTo(BuildContext context, String url) {
    Navigator.pushNamed(context, url);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      hint: Text(optionName!),
      items: getDropdownOptions(pages.keys),
      onChanged: (String? targetPage) {
        final route = pages[targetPage];
        if (route == '/collection' &&
            pageCategories != null &&
            pageCategories![targetPage] != null) {
          Navigator.pushNamed(context, '/collection',
              arguments: pageCategories![targetPage]);
        } else if (route != null) {
          barNavigateTo(context, route);
        }
      },
    );
  }
}

class DetailedDropdown extends StatelessWidget {
  final String? optionName;
  final List<String>? options;

  const DetailedDropdown(
      {super.key, required this.optionName, required this.options});

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        hint: Text(optionName!),
        items: getDropdownOptions(options!),
        onChanged: (String? newValue) {});
  }

  List<DropdownMenuItem<String>> getDropdownOptions(Iterable<String> options) {
    return options
        .map((String page) =>
            DropdownMenuItem<String>(value: page, child: Text(page)))
        .toList();
  }
}

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateTo(BuildContext context, String url) {
    Navigator.pushNamed(context, url);
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            GestureDetector(
                onTap: () {
                  navigateToHome(context);
                },
                child: Row(
                  children: [
                    Image.network(
                      'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                      height: 18,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          width: 18,
                          height: 18,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                    if (size.width > size.height) ...[
                      const NavButton(optionName: "Home", url: "/"),
                      const NavDropdown(
                        optionName: "Shop",
                        pages: {
                          "Clothing": "/collection",
                          "Merchandise": "/collection",
                          "Halloween 🎃": "/collection",
                          "Signature & Essentials Range": "/collection",
                          "Portsmouth City Collection": "/collection",
                          "Pride Collection 🏳️‍🌈": "/collection",
                          "Graduation 🎓": "/collection",
                        },
                        pageCategories: {
                          "Clothing": ProductCategory.clothing,
                          "Merchandise": ProductCategory.merchandise,
                          "Halloween 🎃": ProductCategory.halloween,
                          "Signature & Essentials Range":
                              ProductCategory.signatureAndEssentialsRange,
                          "Portsmouth City Collection":
                              ProductCategory.portsmouthCityCollection,
                          "Pride Collection 🏳️‍🌈":
                              ProductCategory.prideCollection,
                          "Graduation 🎓": ProductCategory.graduation,
                        },
                        options: [],
                      ),
                      const NavDropdown(
                        optionName: "The Print Shack",
                        pages: {
                          "About": "/print_shack/print_about_page",
                          "Personalisation":
                              "/print_shack/print_personalisation_page",
                        },
                        options: [],
                      ),
                      const NavButton(optionName: "SALE!", url: "/collection"),
                      const NavButton(optionName: "About", url: "/about")
                    ]
                  ],
                )),
            const Spacer(),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      size: 18,
                      color: Colors.grey,
                    ),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    onPressed: placeholderCallbackForButtons,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.person_outline,
                      size: 18,
                      color: Colors.grey,
                    ),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    onPressed: () => navigateTo(context, '/account'),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    onPressed: () => navigateTo(context, '/cart'),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      size: 18,
                      color: Colors.grey,
                    ),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    onPressed: () {
                      final items = <MenuItem>[
                        const MenuItem(label: 'Home', route: '/'),
                        const MenuItem(
                          label: 'Shop',
                          children: [
                            MenuItem(
                                label: 'Clothing',
                                route: '/collection',
                                category: ProductCategory.clothing),
                            MenuItem(
                                label: 'Merchandise',
                                route: '/collection',
                                category: ProductCategory.merchandise),
                            MenuItem(
                                label: 'Halloween 🎃',
                                route: '/collection',
                                category: ProductCategory.halloween),
                            MenuItem(
                                label: 'Signature & Essentials Range',
                                route: '/collection',
                                category: ProductCategory
                                    .signatureAndEssentialsRange),
                            MenuItem(
                                label: 'Portsmouth City Collection',
                                route: '/collection',
                                category:
                                    ProductCategory.portsmouthCityCollection),
                            MenuItem(
                                label: 'Pride Collection 🏳️‍🌈',
                                route: '/collection',
                                category: ProductCategory.prideCollection),
                            MenuItem(
                                label: 'Graduation 🎓',
                                route: '/collection',
                                category: ProductCategory.graduation),
                          ],
                        ),
                        const MenuItem(
                          label: 'The Print Shack',
                          children: [
                            MenuItem(
                                label: 'About',
                                route: '/print_shack/print_about_page'),
                            MenuItem(
                                label: 'Personalisation',
                                route:
                                    '/print_shack/print_personalisation_page'),
                          ],
                        ),
                        const MenuItem(
                            label: 'SALE!',
                            route: '/collection',
                            category: ProductCategory.sale),
                        const MenuItem(label: 'About', route: '/about'),
                      ];

                      NavMenu.show(
                        context,
                        items,
                        onNavigate: (item) {
                          if (item.category != null) {
                            Navigator.pushNamed(context, '/collection',
                                arguments: item.category);
                          } else if (item.route != null) {
                            navigateTo(context, item.route!);
                          }
                        },
                        title: 'Menu',
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

class TopBanner extends StatelessWidget {
  const TopBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xFF4d2963),
      child: const Text(
        'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  void register() {}

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: Colors.grey[50],
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const Text(
            "Opening Hours",
            style: FooterText(20),
          ),
          const Text(
            """

(Term Time)

Monday - Friday 9am - 4pm

(Outside of Term Time / Consolidation Weeks)

Monday - Friday 9am - 3pm

Purchase online 24/7
""",
            style: FooterText(16),
          ),
          const SizedBox(height: 16),
          const Text(
            "Help and Information",
            style: FooterText(20),
          ),
          TextButton(
              onPressed: () {},
              child: const Text("Search", style: FooterText(16))),
          TextButton(
              onPressed: () {},
              child: const Text("Terms & Conditions of Sale Policy",
                  style: FooterText(16))),
          const SizedBox(height: 16),
          const Text(
            "Latest Offers",
            style: FooterText(20),
          ),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Email Address',
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: register,
            style: ImportButtonStyle(),
            child: const Text('Subscribe'),
          ),
        ]));
  }
}

class FooterText extends TextStyle {
  const FooterText(double size)
      : super(
          color: Colors.grey,
          fontSize: size,
          fontWeight: FontWeight.w600,
        );
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.white,
      child: const Column(
        children: [
          // Top banner
          TopBanner(),
          // Main header
          NavBar(),
        ],
      ),
    );
  }
}

class ImportButtonStyle extends ButtonStyle {
  ImportButtonStyle()
      : super(
          backgroundColor:
              WidgetStateProperty.all<Color>(const Color(0xFF4d2963)),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        );
}
