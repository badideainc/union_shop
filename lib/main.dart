import 'package:flutter/material.dart';

import 'package:union_shop/product_page.dart';
import 'package:union_shop/about_page.dart';
import 'package:union_shop/print_shack/print_about_page.dart';
import 'package:union_shop/print_shack/print_personal_page.dart';

import 'package:union_shop/models/product_model.dart';

void main() {
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      home: const HomeScreen(),
      // By default, the app starts at the '/' route, which is the HomeScreen
      initialRoute: '/',
      // When navigating to '/product', build and return the ProductPage
      // In your browser, try this link: http://localhost:49856/#/product
      routes: {
        '/product': (context) => ProductPage(product: ProductModel()),
        '/about': (context) => const AboutPage(),
        '/print_shack/print_about_page': (context) => const PrintAboutPage(),
        '/print_shack/print_personalisation_page': (context) =>
            const PrintPersonalisationPage(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            Container(
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
            ),

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
                      children: [
                        ProductCard(product: ProductModel()),
                        ProductCard(product: ProductModel()),
                        ProductCard(product: ProductModel()),
                        ProductCard(product: ProductModel()),
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

class ProductCard extends StatelessWidget {
  // final String title;
  // final String price;
  // final String imageUrl;

  ProductModel product;

  ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
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
                product.name,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Text(
                '£${product.price}',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
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
    return GestureDetector(
      onTap: () {
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

class NavDropdown extends ProductDropdown {
  final Map<String, String> pages;

  const NavDropdown(
      {super.key,
      required this.pages,
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
          barNavigateTo(context, pages[targetPage]!);
        });
  }
}

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
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
                    const NavButton(optionName: "Home", url: "/"),
                    const NavDropdown(
                      optionName: "Shop",
                      pages: {
                        "Clothing": "/",
                        "Merchandise": "/",
                        "Halloween 🎃": "/",
                        "Signature & Essentials Range": "/",
                        "Portsmouth City Collection": "/",
                        "Pride Collection 🏳️‍🌈": "/",
                        "Graduation 🎓": "/",
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
                    const NavButton(optionName: "SALE!", url: "/"),
                    const NavButton(optionName: "About", url: "/about")
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
                    onPressed: placeholderCallbackForButtons,
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
                    onPressed: placeholderCallbackForButtons,
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
                    onPressed: placeholderCallbackForButtons,
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
          const Text(
            """
Search
Terms & Conditions of Sale Policy
""",
            style: FooterText(16),
          ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4d2963),
              foregroundColor: Colors.white,
            ),
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
