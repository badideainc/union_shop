import 'package:flutter/foundation.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/repositories/pricing_repository.dart';

class CartModel extends ChangeNotifier {
  final List<ProductModel> _items = [];

  List<ProductModel> get items => List.unmodifiable(_items);

  // Add a product to the cart. If already present, increment its quantity
  // stored on a snapshot of the ProductModel so personalised selections
  // are captured at the time of adding.
  void add(ProductModel product) {
    // Create a snapshot (deep clone) of the product as it currently is.
    final snapshot = product.clone();
    snapshot.setQuantity(snapshot.quantity > 0 ? snapshot.quantity : 1);

    // If an identical product (same id and same selected options) exists,
    // increase its quantity instead of adding a separate line.
    for (final p in _items) {
      if (p.id == snapshot.id) {
        final bool sameSelections =
            mapEquals(p.selectedOptions, snapshot.selectedOptions);
        if (sameSelections) {
          p.incrementQuantity(snapshot.quantity > 0 ? snapshot.quantity : 1);
          notifyListeners();
          return;
        }
      }
    }

    _items.add(snapshot);
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
    return PricingRepository().calculateTotalPrice(_items);
  }
}
