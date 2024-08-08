import 'list_item.dart';
import 'package:bakery/models/product.dart';
import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  final void Function(Product) onSelectProduct;
  final List<Product> products;

  const ProductList(
    this.products, {
    super.key,
    required this.onSelectProduct,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: InkWell(
          onTap: () {},
          child: ProductListItem(products[index],
              onSelectProduct: onSelectProduct),
        ),
      ),
    );
  }
}
