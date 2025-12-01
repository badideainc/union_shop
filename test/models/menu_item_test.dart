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

  group('MenuItem - nested children', () {
    test('deeper nested children are accessible and preserve order', () {
      const leaf1 = MenuItem(label: 'Leaf 1', route: '/leaf1');
      const leaf2 = MenuItem(label: 'Leaf 2', route: '/leaf2');
      const child = MenuItem(label: 'Child', children: [leaf1, leaf2]);
      const parent = MenuItem(label: 'Parent', children: [child]);

      // parent -> child -> leaf1
      expect(parent.children, isNotNull);
      final childNode = parent.children!.first;
      expect(childNode.label, 'Child');
      expect(childNode.children!.length, 2);
      expect(childNode.children![0].label, 'Leaf 1');
      expect(childNode.children![1].label, 'Leaf 2');
    });

    test('traverse nested children to collect labels', () {
      const leaf = MenuItem(label: 'L', route: '/l');
      const node2 = MenuItem(label: 'N2', children: [leaf]);
      const root = MenuItem(label: 'Root', children: [node2]);

      // simple depth-first traversal
      final labels = <String>[];
      void collect(MenuItem item) {
        labels.add(item.label);
        if (item.children != null) {
          for (final c in item.children!) {
            collect(c);
          }
        }
      }

      collect(root);
      expect(labels, ['Root', 'N2', 'L']);
    });
  });

  group('MenuItem - const and immutability', () {
    test('const constructor produces canonicalized instances', () {
      const a = MenuItem(label: 'ConstItem', route: '/c');
      const b = MenuItem(label: 'ConstItem', route: '/c');
      // Const instances with identical fields should be canonicalized
      expect(identical(a, b), isTrue);
    });

    test('children list is immutable when constructed with const list', () {
      const child = MenuItem(label: 'Child', route: '/child');
      const parent = MenuItem(label: 'Parent', children: [child]);

      // Attempting to mutate the const children list should throw
      expect(() => parent.children!.add(const MenuItem(label: 'X')),
          throwsA(isA<UnsupportedError>()));
    });
  });
}
