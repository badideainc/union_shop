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

// URL-friendly path helpers for routing (used by go_router)
String categoryToPath(ProductCategory c) {
  switch (c) {
    case ProductCategory.clothing:
      return 'clothing';
    case ProductCategory.merchandise:
      return 'merchandise';
    case ProductCategory.halloween:
      return 'halloween';
    case ProductCategory.signatureAndEssentialsRange:
      return 'signature';
    case ProductCategory.portsmouthCityCollection:
      return 'portsmouth';
    case ProductCategory.prideCollection:
      return 'pride';
    case ProductCategory.graduation:
      return 'graduation';
    case ProductCategory.personalised:
      return 'personalised';
    case ProductCategory.sale:
      return 'sale';
  }
}

ProductCategory? pathToCategory(String path) {
  switch (path) {
    case 'clothing':
      return ProductCategory.clothing;
    case 'merchandise':
      return ProductCategory.merchandise;
    case 'halloween':
      return ProductCategory.halloween;
    case 'signature':
      return ProductCategory.signatureAndEssentialsRange;
    case 'portsmouth':
      return ProductCategory.portsmouthCityCollection;
    case 'pride':
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
