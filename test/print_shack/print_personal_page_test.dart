import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/print_shack/print_personal_page.dart';

void main() {
  group('PrintPersonalisationPage - initial loading', () {
    testWidgets('shows loading indicator while base product loads',
        (tester) async {
      await tester.pumpWidget(const MediaQuery(
        data: MediaQueryData(size: Size(1200, 900)),
        child: MaterialApp(home: PrintPersonalisationPage()),
      ));

      // Immediately after pump, the FutureBuilder will show a loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
