import 'package:flutter/widgets.dart';
import 'package:union_shop/models/category.dart';

class MenuItem {
  final String label;
  final String? route;
  final List<MenuItem>? children;
  final IconData? icon;
  final String? id;
  final ProductCategory? category;

  const MenuItem({
    required this.label,
    this.route,
    this.children,
    this.icon,
    this.id,
    this.category,
  });
}
