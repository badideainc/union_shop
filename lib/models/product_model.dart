class ProductModel {
  final String id;
  final String name;
  final String description;

  //Broad array for the different types of the item
  final List<String> options;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.options,
  });
}
