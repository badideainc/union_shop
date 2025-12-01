import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/account_page.dart';

void main() {
  testWidgets('AccountPage shows AppBar title and main headings',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AccountPage()));
    await tester.pumpAndSettle();

    // AppBar title
    expect(find.text('Account Page'), findsOneWidget);

    // Main headings
    expect(find.text('The UNION'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('Sign in with shop button exists and is disabled',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AccountPage()));
    await tester.pumpAndSettle();

    final finder = find.widgetWithText(ElevatedButton, 'Sign in with shop');
    expect(finder, findsOneWidget);

    final ElevatedButton button = tester.widget<ElevatedButton>(finder);
    expect(button.onPressed, isNull);
  });
}
