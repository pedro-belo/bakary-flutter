import 'package:bakery/models/product.dart';
import 'package:flutter/material.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final void Function(Product) onSelectProduct;

  const ProductListItem(this.product,
      {super.key, required this.onSelectProduct});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onSelectProduct(product),
      tileColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.primaryContainer,
      title: Text(
        product.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        product.category.name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w200,
        ),
      ),
    );
  }
}
