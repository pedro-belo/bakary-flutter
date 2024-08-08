import 'package:bakery/models/product.dart';
import 'package:bakery/models/production.dart';
import 'package:bakery/utils.dart' as utils;
import 'package:bakery/widget/confirm_action.dart';
import 'package:flutter/material.dart';

class ProductDeleteConfirmationScreen extends StatelessWidget {
  final void Function(Product product) onProductDeleteConfirmation;
  final Product product;
  final List<Production> production;

  const ProductDeleteConfirmationScreen({
    super.key,
    required this.product,
    required this.production,
    required this.onProductDeleteConfirmation,
  });

  String getWarningMessage() {
    String s1 = "Tem certeza que deseja remover o produto '${product.name}' ?";

    if (production.isEmpty) {
      return s1;
    }

    return s1 +
        (production.length > 1
            ? " Existem ${production.length} itens de produção relacionados a ele que também serão removidos."
            : " Existe 1 item de produção relacionado a ele que também será removido.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.createAppBar(context, title: "Confirme ação"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ConfirmAction(
          message: getWarningMessage(),
          onConfirmation: () {
            onProductDeleteConfirmation(product);
          },
        ),
      ),
    );
  }
}
