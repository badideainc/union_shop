import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/json_parser.dart';

void main() {
  // Ensure binding so we can intercept asset channel messages.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('loadProductData - valid JSON', () {
    testWidgets('returns product list for valid assets/products.json',
        (WidgetTester tester) async {
      const assetKey = 'assets/products.json';

      final sample = json.encode({
        'products': [
          {'id': 'p1', 'name': 'Apple'},
          {'id': 'p2', 'name': 'Banana'}
        ]
      });

      tester.binding.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        if (message == null) return null;
        final requested = utf8.decode(message.buffer.asUint8List());
        if (requested == assetKey) {
          final bytes = utf8.encode(sample);
          return ByteData.view(Uint8List.fromList(bytes).buffer);
        }
        return null;
      });

      final result = await loadProductData();

      // Clean up mock handler so other tests are not affected.
      // ignore: deprecated_member_use
      tester.binding.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', null);

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, 2);
      expect(result[0]['id'], 'p1');
      expect(result[1]['name'], 'Banana');
    });
  });
}
