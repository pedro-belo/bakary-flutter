import 'list_item.dart';
import 'package:bakery/models/product.dart';
import 'package:bakery/models/production.dart';
import 'package:flutter/material.dart';

final mounths = [
  ("Janeiro", 1),
  ("Fevereiro", 2),
  ("Março", 3),
  ("Abril", 4),
  ("Maio", 5),
  ("Junho", 6),
  ("Julho", 7),
  ("Agosto", 8),
  ("Setembro", 9),
  ("Outubro", 10),
  ("Novembro", 11),
  ("Dezembro", 12),
];

class ProductionList extends StatelessWidget {
  final List<Product> products;
  final List<Production> production;

  const ProductionList({
    super.key,
    required this.production,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mounths.length,
      itemBuilder: (context, index) {
        return ProductionListItem(
          products: products,
          monthName: mounths[index].$1,
          monthId: mounths[index].$2,
          production: production,
        );
      },
    );
  }
}
