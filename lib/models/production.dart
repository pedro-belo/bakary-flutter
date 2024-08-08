class Production {
  int id;
  int productId;
  double productionPrice;
  double salePrice;
  int quantity;
  DateTime date;

  double get totalProductionPrice {
    return productionPrice * quantity;
  }

  double get totalSalePrice {
    return salePrice * quantity;
  }

  Production({
    required this.id,
    required this.productId,
    required this.productionPrice,
    required this.salePrice,
    required this.quantity,
    required this.date,
  });

  factory Production.fromJson(Map<String, dynamic> productionData) {
    return Production(
      id: productionData["id"] as int,
      productId: productionData["product_id"] as int,
      productionPrice:
          double.parse(productionData["production_price"] as String),
      salePrice: double.parse(productionData["sale_price"] as String),
      quantity: productionData["quantity"] as int,
      date: DateTime.parse(productionData["date"]),
    );
  }

  Map<String, dynamic> toJson({bool useId = true}) {
    Map<String, dynamic> productionData = {
      "product_id": productId,
      "production_price": productionPrice,
      "sale_price": salePrice,
      "quantity": quantity,
      "date": date.toIso8601String(),
    };

    if (useId) {
      productionData["id"] = id;
    }

    return productionData;
  }
}
