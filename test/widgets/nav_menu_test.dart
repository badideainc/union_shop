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

  testWidgets('NavMenu shows provided title and Close button', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                NavMenu.show(context, const [MenuItem(label: 'A')],
                    title: 'My Menu');
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

    // The custom title should be visible and Close button present
    expect(find.text('My Menu'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Close'), findsOneWidget);
  });

  testWidgets('tapping a parent row opens its children', (tester) async {
    final items = <MenuItem>[
      const MenuItem(
        label: 'Parent',
        children: [
          MenuItem(label: 'Child1', route: '/child1'),
          MenuItem(label: 'Child2', route: '/child2'),
        ],
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                NavMenu.show(context, items);
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

    // Parent should be visible
    expect(find.text('Parent'), findsOneWidget);

    // Tap Parent to open children
    await tester.tap(find.text('Parent'));
    await tester.pumpAndSettle();

    // Child entries should now be visible
    expect(find.text('Child1'), findsOneWidget);
    expect(find.text('Child2'), findsOneWidget);
  });

  testWidgets('Back row returns to parent menu', (tester) async {
    final items = <MenuItem>[
      const MenuItem(
        label: 'Parent',
        children: [
          MenuItem(label: 'Child1', route: '/child1'),
          MenuItem(label: 'Child2', route: '/child2'),
        ],
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                NavMenu.show(context, items);
              },
              child: const Text('Open'),
            ),
          ),
        );
      }),
    ));

    // Open the menu and drill into children
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Parent'));
    await tester.pumpAndSettle();

    // Confirm we're in child view
    expect(find.text('Child1'), findsOneWidget);

    // Tap Back to return
    final backFinder = find.text('Back');
    expect(backFinder, findsOneWidget);
    await tester.tap(backFinder);
    await tester.pumpAndSettle();

    // Parent should be visible again and children not visible
    expect(find.text('Parent'), findsOneWidget);
    expect(find.text('Child1'), findsNothing);
  });

  testWidgets('leaf navigation calls onNavigate and closes dialog',
      (tester) async {
    final items = <MenuItem>[
      const MenuItem(label: 'Leaf', route: '/leaf'),
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

    // Leaf should be visible
    expect(find.text('Leaf'), findsOneWidget);

    // Tap Leaf - should call onNavigate and close the dialog
    await tester.tap(find.text('Leaf'));
    await tester.pumpAndSettle();

    expect(navigatedItem, isNotNull);
    expect(navigatedItem!.label, 'Leaf');

    // Dialog should be closed (Close button not present)
    expect(find.text('Close'), findsNothing);
  });
}
