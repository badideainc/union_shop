import 'dart:convert';
import 'package:flutter/services.dart';

/// Load product data from the default asset bundle.
///
/// An optional [loader] may be provided for tests to inject a JSON string
/// directly without relying on the platform asset channel.
Future<List<Map<String, dynamic>>> loadProductData({
  Future<String> Function()? loader,
}) async {
  final loaderFn =
      loader ?? () => rootBundle.loadString('assets/products.json');
  final String jsonString = await loaderFn();
  final Map<String, dynamic> jsonData = json.decode(jsonString);
  return List<Map<String, dynamic>>.from(jsonData['products']);
}
