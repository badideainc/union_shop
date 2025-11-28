import 'package:flutter/widgets.dart';

class MenuItem {
  final String label;
  final String? route;
  final List<MenuItem>? children;
  final IconData? icon;
  final String? id;

  const MenuItem({
    required this.label,
    this.route,
    this.children,
    this.icon,
    this.id,
  });
}
