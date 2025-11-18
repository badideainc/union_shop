import 'package:union_shop/json_parser.dart';

class ProductModel {
  final String _id;
  String _name = "";
  String _description = "";
  String _imageUrl = "";

  int _quantity = 0;
  int _price = 0;
  //Broad array for the different types of the item
  Map<String, List<String>>? _options;

  ProductModel({required this.id});

  static Future<ProductModel> productFromJson(String id) async {
    {
      final productList = await loadProductData();
      for (final productData in productList) {
        if (productData['id'] == id) {
          final model = ProductModel(id: id);
          model._name = productData['name'] ?? model._name;
          model._description = productData['description'] ?? model._description;
          model._imageUrl = productData['imageUrl'] ?? model._imageUrl;
          model._price = productData['price'] ?? model._price;
          return model;
        }
      }
      return ProductModel(id: id);
    }
  }

  String get id => _id;
  String get name => _name;
  String get description => _description;
  String get imageUrl => _imageUrl;
  int get price => _price;
  int get quantity => _quantity;
  Map<String, List<String>>? get options => _options;
}
