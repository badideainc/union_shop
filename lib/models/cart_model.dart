import 'package:union_shop/models/product_model.dart';

class CartModel {
  final List<ProductModel> _items = [];

  void addItem(ProductModel product) {
    _items.add(product);
  }

  void removeItem(ProductModel product) {
    _items.remove(product);
  }

  void clearCart() {
    _items.clear();
  }

  List<ProductModel> get items => _items;
}
