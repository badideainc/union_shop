enum ProductCategory {
  clothing,
  merchandise,
  halloween,
  signatureAndEssentialsRange,
  portsmouthCityCollection,
  prideCollection,
  graduation,
  personalised,
  sale
}

String categoryTitle(ProductCategory c) {
  switch (c) {
    case ProductCategory.clothing:
      return 'Clothing';
    case ProductCategory.merchandise:
      return 'Merchandise';
    case ProductCategory.halloween:
      return 'Halloween 🎃';
    case ProductCategory.signatureAndEssentialsRange:
      return 'Signature & Essentials Range';
    case ProductCategory.portsmouthCityCollection:
      return 'Portsmouth City Collection';
    case ProductCategory.prideCollection:
      return 'Pride Collection 🏳️‍🌈';
    case ProductCategory.graduation:
      return 'Graduation 🎓';
    case ProductCategory.personalised:
      return 'Personalised Items';
    case ProductCategory.sale:
      return 'SALE!';
  }
}

ProductCategory? categoryFromString(String? categoryString) {
  switch (categoryString) {
    case 'clothing':
      return ProductCategory.clothing;
    case 'merchandise':
      return ProductCategory.merchandise;
    case 'halloween':
      return ProductCategory.halloween;
    case 'signatureAndEssentialsRange':
      return ProductCategory.signatureAndEssentialsRange;
    case 'portsmouthCityCollection':
      return ProductCategory.portsmouthCityCollection;
    case 'prideCollection':
      return ProductCategory.prideCollection;
    case 'graduation':
      return ProductCategory.graduation;
    case 'personalised':
      return ProductCategory.personalised;
    case 'sale':
      return ProductCategory.sale;
    default:
      return null;
  }
}
