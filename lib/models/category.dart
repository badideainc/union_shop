enum Category {
  clothing,
  merchandise,
  halloween,
  signatureAndEssentialsRange,
  portsmouthCityCollection,
  prideCollection,
  graduation,
}

String categoryTitle(Category c) {
  switch (c) {
    case Category.clothing:
      return 'Clothing';
    case Category.merchandise:
      return 'Merchandise';
    case Category.halloween:
      return 'Halloween 🎃';
    case Category.signatureAndEssentialsRange:
      return 'Signature & Essentials Range';
    case Category.portsmouthCityCollection:
      return 'Portsmouth City Collection';
    case Category.prideCollection:
      return 'Pride Collection 🏳️‍🌈';
    case Category.graduation:
      return 'Graduation 🎓';
  }
}
