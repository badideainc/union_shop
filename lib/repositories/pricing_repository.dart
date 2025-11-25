import "package:union_shop/models/product_model.dart";

class PricingRepository {
  double calculateTotalPrice(List<ProductModel> products) {
    double price = 0.0;

    for (ProductModel product in products) {
      price += product.price;
    }
    return price;
  }
}
