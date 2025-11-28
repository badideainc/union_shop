import 'package:union_shop/json_parser.dart';
import 'package:union_shop/models/category.dart';

class ProductModel {
  String _id = "";
  String _name = "";
  String _description = "";
  String _imageUrl = "";

  List<ProductCategory>? _category;

  int _quantity = 0;
  double _price = 0;
  double _salePrice = -1;
  //Broad array for the different types of the item
  Map<String, List<String>>? _options;
  // Store the current selection for each option key (e.g. "Size": "M").
  Map<String, String>? _selectedOptions;

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
          final dynamic catField = productData['category'];
          if (catField is List) {
            model._category = catField
                .map((e) => categoryFromString(e?.toString()))
                .whereType<ProductCategory>()
                .toList();
          } else {
            final ProductCategory? parsed =
                categoryFromString(catField?.toString());
            if (parsed != null) model._category = [parsed];
          }
          model._price = productData['price'] ?? model._price;
          // Parse options map (JSON may store a Map<String, List<String>> as dynamic)
          final dynamic opts = productData['options'];
          if (opts is Map) {
            model._options = opts.map<String, List<String>>((key, value) {
              if (value is List) {
                return MapEntry(key.toString(),
                    value.map((e) => e?.toString() ?? '').toList());
              } else {
                return MapEntry(key.toString(), [value?.toString() ?? '']);
              }
            });
            // Initialise selected options map so UI can write selections
            model._selectedOptions = {};
          }
          model._salePrice = productData['salePrice'] ?? model._salePrice;
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

  List<ProductCategory>? get category => _category;

  double get price => _price;
  double get salePrice => _salePrice;

  int get quantity => _quantity;
  Map<String, List<String>>? get options => _options;
  Map<String, String>? get selectedOptions => _selectedOptions;

  // Mutators for quantity so other code can update product quantity when
  // the product instance is used as a cart item.
  void setQuantity(int q) {
    _quantity = q;
  }

  /// Set a selection for an option key.
  void setSelectedOption(String key, String value) {
    _selectedOptions ??= {};
    _selectedOptions![key] = value;
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
    // Copy pricing fields
    target._salePrice = _salePrice;
    // Copy options (deep copy lists) so target can be mutated independently
    target._options = _options == null
        ? null
        : Map.fromEntries(
            _options!.entries.map((e) => MapEntry(e.key, List.from(e.value))));
    // Copy selected options if present so personalised selections persist
    target._selectedOptions =
        _selectedOptions == null ? null : Map.from(_selectedOptions!);
    // Copy quantity state
    target._quantity = _quantity;
  }

  /// Return a deep-cloned snapshot of this product suitable for storing in the cart.
  ProductModel clone() {
    final ProductModel t = ProductModel();
    copyTo(t);
    return t;
  }
}
