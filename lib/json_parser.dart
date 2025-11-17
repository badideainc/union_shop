import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<Map<String, dynamic>>> loadProductData() async {
  final String jsonString = await rootBundle.loadString('assets/products.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);
  return List<Map<String, dynamic>>.from(jsonData['products']);
}
