import 'package:bakery/models/product.dart';
import 'package:bakery/models/production.dart';
import 'package:flutter/material.dart';

class ProductionListItem extends StatelessWidget {
  final int monthId;
  final String monthName;
  final List<Production> production;
  final List<Product> products;

  const ProductionListItem({
    super.key,
    required this.monthId,
    required this.monthName,
    required this.products,
    required this.production,
  });

  Widget _createListTileForUnproducedProduct(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.primary.withAlpha(50),
      title: Text(
        monthName,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primaryContainer),
      ),
      subtitle: Text(
        'O mes de $monthName não teve produção.',
        style: const TextStyle(fontWeight: FontWeight.w300),
      ),
    );
  }

  Widget _createListTileForProducedProduct(
    BuildContext context,
    Product product,
    List<Production> productions,
  ) {
    final results = _productionsSum(product, productions);
    double expenses = results['expenses'] as double;
    double revenue = results['revenue'] as double;
    double expectedProfit = (results["expectedProfit"] as double).abs();

    return ListTile(
      tileColor: Theme.of(context).colorScheme.primary.withAlpha(25),
      title: Text(
        product.name,
        style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer),
      ),
      subtitle: Text(
        'Despesa: ${expenses.toStringAsFixed(2)} R\$, Produção: ${revenue.toStringAsFixed(2)} R\$, ${expectedProfit > 0 ? 'Receita' : 'Prejuizo'}: ${expectedProfit.abs().toStringAsFixed(2)} R\$',
      ),
    );
  }

  Map<Product, List<Production>> _groupProductionsByProduct() {
    Map<Product, List<Production>> productProduction = {};

    for (var product in products) {
      List<Production> result = production
          .where((p) => p.productId == product.id && p.date.month == monthId)
          .toList();

      if (result.isNotEmpty) {
        productProduction[product] = result;
      }
    }

    return productProduction;
  }

  Map<String, double> _productionsSum(
      Product product, List<Production> productions) {
    double expenses = 0.0;
    double revenue = 0.0;

    for (var production in productions) {
      expenses += production.totalProductionPrice;
      revenue += production.totalSalePrice;
    }

    return {
      "expenses": expenses,
      "revenue": revenue,
      "expectedProfit": revenue - expenses,
    };
  }

  @override
  Widget build(BuildContext context) {
    Map<Product, List<Production>> productProductions =
        _groupProductionsByProduct();

    if (productProductions.isEmpty) {
      return _createListTileForUnproducedProduct(context);
    }

    return ExpansionTile(
      backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(50),
      collapsedBackgroundColor: Theme.of(context).colorScheme.primary,
      collapsedTextColor: Theme.of(context).colorScheme.primaryContainer,
      collapsedIconColor: Theme.of(context).colorScheme.primaryContainer,
      iconColor: Theme.of(context).colorScheme.primaryContainer,
      title: Text(
        monthName,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
      ),
      children: productProductions.entries
          .map(
            (entry) => _createListTileForProducedProduct(
              context,
              entry.key,
              entry.value,
            ),
          )
          .toList(),
    );
  }
}
