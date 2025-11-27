import 'package:union_shop/json_parser.dart';
import 'package:union_shop/models/category.dart';

class ProductModel {
  String _id = "";
  String _name = "";
  String _description = "";
  String _imageUrl = "";

  ProductCategory? _category;

  int _quantity = 0;
  double _price = 0;
  //Broad array for the different types of the item
  Map<String, List<String>>? _options;

  ProductModel();

  static Future<ProductModel> productFromJson(String id) async {
    {
      final productList = await loadProductData();
      for (final productData in productList) {
        if (productData['id'] == id) {
          final model = ProductModel();
          model._id = productData['id'] ?? model._id;
          model._name = productData['name'] ?? model._name;
          model._description = productData['description'] ?? model._description;
          model._imageUrl = productData['imageUrl'] ?? model._imageUrl;
          model._category = categoryFromString(productData['category']);
          model._price = productData['price'] ?? model._price;
          return model;
        }
      }
      return ProductModel();
    }
  }

  String get id => _id;
  String get name => _name;
  String get description => _description;
  String get imageUrl => _imageUrl;

  ProductCategory? get category => _category;

  double get price => _price;
  int get quantity => _quantity;
  Map<String, List<String>>? get options => _options;

  // Mutators for quantity so other code can update product quantity when
  // the product instance is used as a cart item.
  void setQuantity(int q) {
    _quantity = q;
  }

  void incrementQuantity([int delta = 1]) {
    _quantity += delta;
  }

  void decrementQuantity([int delta = 1]) {
    if (_quantity - delta <= 0) return;

    _quantity -= delta;
  }

  /// Copy core (public) fields into another ProductModel instance.
  /// This allows creating product-based variants (e.g. personalised items)
  /// without exposing the private fields outside this file.
  void copyTo(ProductModel target) {
    target._id = _id;
    target._name = _name;
    target._description = _description;
    target._imageUrl = _imageUrl;
    target._category = _category;
    target._price = _price;
  }
}
