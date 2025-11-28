import 'package:flutter/material.dart';
import 'package:union_shop/models/menu_item.dart';

class NavMenu extends StatefulWidget {
  final List<MenuItem> items;
  final void Function(String route)? onNavigate;
  final String? title;

  const NavMenu({super.key, required this.items, this.onNavigate, this.title});

  static Future<void> show(BuildContext context, List<MenuItem> items,
      {void Function(String route)? onNavigate, String? title}) {
    return showDialog<void>(
      context: context,
      builder: (context) =>
          NavMenu(items: items, onNavigate: onNavigate, title: title),
    );
  }

  @override
  State<NavMenu> createState() => _NavMenuState();
}

class _NavMenuState extends State<NavMenu> {
  final List<List<MenuItem>> _stack = [];

  @override
  void initState() {
    super.initState();
    _stack.add(widget.items);
  }

  void _openChildren(List<MenuItem> children) {
    setState(() => _stack.add(children));
  }

  void _back() {
    if (_stack.length > 1) setState(() => _stack.removeLast());
  }

  @override
  Widget build(BuildContext context) {
    final current = _stack.isNotEmpty ? _stack.last : <MenuItem>[];

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Text(widget.title ?? 'Menu',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            const Divider(height: 1),

            // Menu list
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: current.length + (_stack.length > 1 ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_stack.length > 1 && index == 0) {
                    // Back row: show parent heading if available
                    final parentTitle = 'Back';
                    return ListTile(
                      leading: const Icon(Icons.arrow_back),
                      title: Text('< $parentTitle'),
                      onTap: _back,
                    );
                  }

                  final item = current[index - (_stack.length > 1 ? 1 : 0)];

                  return ListTile(
                    leading: item.icon != null ? Icon(item.icon) : null,
                    title: Text(item.label),
                    trailing: item.children != null
                        ? const Icon(Icons.chevron_right)
                        : null,
                    onTap: () {
                      if (item.children != null && item.children!.isNotEmpty) {
                        _openChildren(item.children!);
                      } else if (item.route != null) {
                        Navigator.of(context).pop();
                        widget.onNavigate?.call(item.route!);
                      }
                    },
                  );
                },
              ),
            ),

            // Footer / Close
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
