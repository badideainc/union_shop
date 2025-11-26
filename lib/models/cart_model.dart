import 'package:flutter/foundation.dart';
import 'package:union_shop/models/product_model.dart';

class CartModel extends ChangeNotifier {
  final List<ProductModel> _items = [];

  List<ProductModel> get items => List.unmodifiable(_items);

  // Add a product to the cart. If already present, increment its quantity
  // stored on the ProductModel itself.
  void add(ProductModel product) {
    for (final p in _items) {
      if (p.id == product.id) {
        p.incrementQuantity(1);
        notifyListeners();
        return;
      }
    }

    // If not present, ensure the product has at least quantity 1 and add
    product.setQuantity(product.quantity > 0 ? product.quantity : 1);
    _items.add(product);
    notifyListeners();
  }

  // Decrease quantity by one; remove item if quantity reaches zero
  void decrease(String productId) {
    for (var i = 0; i < _items.length; i++) {
      final p = _items[i];
      if (p.id == productId) {
        if (p.quantity > 1) {
          p.decrementQuantity(1);
        } else {
          _items.removeAt(i);
        }
        notifyListeners();
        return;
      }
    }
  }

  void updateQuantity(String productId, int quantity) {
    for (var i = 0; i < _items.length; i++) {
      final p = _items[i];
      if (p.id == productId) {
        if (quantity <= 0) {
          _items.removeAt(i);
        } else {
          p.setQuantity(quantity);
        }
        notifyListeners();
        return;
      }
    }
  }

  /// Remove an item from the cart immediately (regardless of quantity).
  void remove(String productId) {
    _items.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice {
    double sum = 0.0;
    for (final p in _items) {
      sum += p.price * p.quantity;
    }
    return sum;
  }
}
