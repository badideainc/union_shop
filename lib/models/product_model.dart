class ProductModel {
  final String id;
  final String name;
  final String description;

  final int quantity;
  final int price;

  //Broad array for the different types of the item
  final Map<String, List<String>>? options;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    this.options,
    this.quantity = 1,
    required this.price,
  });
}
