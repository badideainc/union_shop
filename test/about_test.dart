import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/about_page.dart';
import 'package:union_shop/main.dart';

void main() {
  testWidgets('AboutPage shows Header, title and Footer', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutPage()));
    await tester.pumpAndSettle();

    // Header widget should be present
    expect(find.byType(Header), findsOneWidget);

    // The page title
    expect(find.text('About Us'), findsOneWidget);

    // Footer should be present
    expect(find.byType(Footer), findsOneWidget);

    // Paragraph contains contact email
    expect(find.textContaining('hello@upsu.net'), findsOneWidget);
  });

  testWidgets('AboutPage contains contact email', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutPage()));
    await tester.pumpAndSettle();

    expect(find.textContaining('hello@upsu.net'), findsOneWidget);
  });
}
