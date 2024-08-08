import 'package:bakery/models/product.dart';
import 'package:bakery/provider/product_provider.dart';
import 'package:bakery/utils.dart' as utils;
import 'package:bakery/widget/product/form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class CreateProductScreen extends ConsumerWidget {
  const CreateProductScreen({super.key});

  Future<void> onCreateProduct(
    Product product,
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      await ref.read(productProvider.notifier).create(product);
      if (context.mounted) {
        utils.snackBarSuccess(context,
            message: "Produto ${product.name} foi criado.");
        Navigator.pop(context);
      }
    } catch (err) {
      utils.snackBarError(context, message: err.toString());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: utils.createAppBar(context, title: "Novo Produto"),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ProductForm(
          onCreateProduct: (Product product) async {
            await onCreateProduct(product, context, ref);
          },
        ),
      ),
    );
  }
}
