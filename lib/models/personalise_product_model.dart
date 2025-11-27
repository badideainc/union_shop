import 'package:union_shop/models/product_model.dart';

class PersonaliseProductModel extends ProductModel {
  /// Lines of personalised text (may be empty). Assigned later.
  late final List<String> personalisedText;

  /// True when the personalisation is a logo selection rather than text.
  late final bool isLogo;

  PersonaliseProductModel() : super();

  void setText(String? text, int lineNumber) {
    if (lineNumber < 0 || lineNumber >= personalisedText.length) {
      return;
    }
    personalisedText[lineNumber] = text ?? "";
  }

  void setIsLogo(bool logo) {
    isLogo = logo;
  }

  double overallPrice(String text) {
    double basePrice = super.price;
    if (isLogo) {
      basePrice =
          text == "Small Logo (Chest)" ? basePrice = 3.5 : basePrice = 5.0;
    } else {
      basePrice += 2.0 * personalisedText.length;
    }
    return basePrice;
  }
}
