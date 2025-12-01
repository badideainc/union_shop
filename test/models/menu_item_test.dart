import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:union_shop/models/menu_item.dart';
import 'package:union_shop/models/category.dart';

void main() {
  group('MenuItem - construction', () {
    test('basic fields set correctly', () {
      const iconData = IconData(0xe88a, fontFamily: 'MaterialIcons');
      const item = MenuItem(
        label: 'Home',
        route: '/',
        id: 'home',
        icon: iconData,
        category: ProductCategory.clothing,
      );

      expect(item.label, 'Home');
      expect(item.route, '/');
      expect(item.id, 'home');
      expect(item.icon, iconData);
      expect(item.category, ProductCategory.clothing);
    });

    test('children can be nested and are accessible', () {
      const child = MenuItem(label: 'Sub', route: '/sub');
      const parent = MenuItem(label: 'Parent', children: [child]);

      expect(parent.children, isNotNull);
      expect(parent.children!.length, 1);
      expect(parent.children!.first.label, 'Sub');
    });
  });
}
