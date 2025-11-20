import 'package:flutter/material.dart';
import 'package:union_shop/models/category.dart';

class CollectionPage extends StatefulWidget {
  final Category category;

  const CollectionPage({super.key, required this.category});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryTitle(widget.category))),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
