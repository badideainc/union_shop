import 'package:union_shop/models/product_model.dart';

class PersonaliseProductModel extends ProductModel {
  /// Lines of personalised text (may be empty). Assigned later.
  late final List<String> personalisedText;

  /// True when the personalisation is a logo selection rather than text.
  late final bool isLogo;
}
