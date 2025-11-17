import 'package:union_shop/json_parser.dart';

class ProductModel {
  final String id;
  String name = "";
  String description = "";
  String imageUrl = "";

  int quantity = 0;
  int price = 0;

  //Broad array for the different types of the item
  Map<String, List<String>>? options;

  ProductModel({required this.id});

  static Future<ProductModel> productFromJson(String id) async {
    {
      final productList = await loadProductData();
      for (final productData in productList) {
        if (productData['id'] == id) {
          final model = ProductModel(id: id);
          model.name = productData['name'] ?? model.name;
          model.description = productData['description'] ?? model.description;
          model.imageUrl = productData['imageUrl'] ?? model.imageUrl;
          model.price = productData['price'] ?? model.price;
          return model;
        }
      }
      return ProductModel(id: id);
    }
  }
}
