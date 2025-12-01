import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/json_parser.dart';

void main() {
  // Ensure binding so we can intercept asset channel messages.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('loadProductData - valid JSON', () {
    testWidgets('returns product list for valid assets/products.json',
        (WidgetTester tester) async {
      final sample = json.encode({
        'products': [
          {'id': 'p1', 'name': 'Apple'},
          {'id': 'p2', 'name': 'Banana'}
        ]
      });

      // Inject a loader to avoid relying on the platform asset channel.
      final result = await loadProductData(loader: () async => sample);

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, 2);
      expect(result[0]['id'], 'p1');
      expect(result[1]['name'], 'Banana');
    });
  });

  group('loadProductData - invalid JSON', () {
    testWidgets('throws FormatException for malformed JSON',
        (WidgetTester tester) async {
      // Provide a deliberately malformed JSON payload
      const sample = 'not a json payload';

      // Inject a loader that returns malformed JSON so the function throws
      // during decode.
      await expectLater(loadProductData(loader: () async => sample),
          throwsA(isA<FormatException>()));
    });
  });

  group("loadProductData - missing 'products' key", () {
    testWidgets('throws when products key is missing',
        (WidgetTester tester) async {
      // Valid JSON but missing the 'products' key
      final sample = json.encode({'not_products': []});

      // Inject a loader which returns valid JSON that doesn't contain the
      // expected 'products' key.
      await expectLater(
          loadProductData(loader: () async => sample), throwsA(isA<Object>()));
    });
  });
}
