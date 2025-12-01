import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/widgets/nav_menu.dart';
import 'package:union_shop/models/menu_item.dart';

void main() {
  testWidgets('NavMenu opens, navigates into children and calls onNavigate',
      (tester) async {
    final items = <MenuItem>[
      const MenuItem(
        label: 'Parent',
        children: [
          MenuItem(label: 'Child1', route: '/child1'),
          MenuItem(label: 'Child2', route: '/child2'),
        ],
      ),
      const MenuItem(label: 'Alone', route: '/alone'),
    ];

    MenuItem? navigatedItem;

    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                NavMenu.show(context, items, onNavigate: (item) {
                  navigatedItem = item;
                });
              },
              child: const Text('Open'),
            ),
          ),
        );
      }),
    ));

    // Open the menu dialog
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Menu should be visible
    expect(find.text('Menu'), findsOneWidget);

    // Tap the Parent row to open children
    expect(find.text('Parent'), findsOneWidget);
    await tester.tap(find.text('Parent'));
    await tester.pumpAndSettle();

    // Now child entries should be visible
    expect(find.text('Child1'), findsOneWidget);
    expect(find.text('Child2'), findsOneWidget);

    // Tap Child1 - should call onNavigate with that item and close the dialog
    await tester.tap(find.text('Child1'));
    await tester.pumpAndSettle();

    expect(navigatedItem, isNotNull);
    expect(navigatedItem!.label, 'Child1');
  });
}
