enum ProductCategory {
  bolos(1),
  tortas(2),
  doces(3),
  salgados(4),
  biscoitos(5),
  bebidas(6),
  paes(7);

  factory ProductCategory.fromValue(int value) {
    try {
      return ProductCategory.values
          .firstWhere((category) => category.value == value);
    } catch (e) {
      throw ArgumentError("Invalid ProductCategory value: $value");
    }
  }

  final int value;
  const ProductCategory(this.value);
}

class Product {
  final int id;
  final String name;
  final ProductCategory category;

  const Product({
    required this.id,
    required this.name,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> productData) {
    return Product(
      id: productData['id'] as int,
      name: productData['name'] as String,
      category: ProductCategory.fromValue(productData['category'] as int),
    );
  }

  Map<String, dynamic> toJson({bool useId = true}) {
    Map<String, dynamic> productData = {
      "name": name,
      "category": category.value,
    };

    if (useId) {
      productData["id"] = id;
    }

    return productData;
  }
}
