import "package:union_shop/models/product_model.dart";

class PricingRepository {
  double calculateTotalPrice(List<ProductModel> products) {
    if (products.isEmpty) {
      return 0.0;
    }

    double price = 0.0;

    for (ProductModel product in products) {
      if (product.salePrice >= 0) {
        price += product.salePrice * product.quantity;
        continue;
      }

      price += product.price * product.quantity;
    }
    return price;
  }
}
