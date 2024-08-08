import 'package:bakery/models/product.dart';
import 'package:bakery/models/production.dart';
import 'package:bakery/provider/product_provider.dart';
import 'package:bakery/provider/production_provider.dart';
import 'package:bakery/screen/product/delete_confirmation.dart';
import 'package:bakery/utils.dart' as utils;
import 'package:bakery/widget/error_retry.dart';
import 'package:bakery/widget/loading_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailScreen(this.product, {super.key});

  void navigateToProductDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    Product product,
    List<Production> production,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => ProductDeleteConfirmationScreen(
          product: product,
          production: production,
          onProductDeleteConfirmation: (Product product) =>
              onProductDeleteConfirmation(context, ref, product),
        ),
      ),
    );
  }

  Future<void> onProductDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    Product product,
  ) async {
    try {
      await ref.read(productProvider.notifier).delete(product);
      ref
          .read(productionProvider.notifier)
          .syncStateAfterProductDeletion(product.id);

      if (context.mounted) {
        utils.snackBarSuccess(
          context,
          message: "Produto ${product.name} foi removido.",
        );

        Navigator.pop(context);
      }
    } catch (err) {
      utils.snackBarError(context, message: err.toString());
    }
  }

  Widget _buildMainScreen({
    required BuildContext context,
    required WidgetRef ref,
    required List<Production> productProduction,
  }) {
    return Scaffold(
      appBar: utils.createAppBar(
        context,
        title: product.name,
        actions: [
          IconButton(
            onPressed: () {
              navigateToProductDeleteConfirmation(
                context,
                ref,
                product,
                productProduction,
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: const Center(
        child: Text("Não Implementado"),
      ),
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      appBar: utils.createAppBar(context, title: "Aguarde"),
      body: LoadingData(
        description: "Carregando produção do produto ${product.name}",
      ),
    );
  }

  Widget _buildErrorScreen(BuildContext context, WidgetRef ref, Object error) {
    return Scaffold(
      appBar: utils.createAppBar(context, title: "Erro"),
      body: ErrorRetry(
        message: error.toString(),
        onTryAgain: () {
          ref.invalidate(productionProvider);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final production = ref.watch(productionProvider);

    return production.when(
      data: (productionData) => _buildMainScreen(
        context: context,
        ref: ref,
        productProduction: productionData.getProductionsForProduct(product.id),
      ),
      error: (error, stackTrace) => _buildErrorScreen(context, ref, error),
      loading: () => _buildLoadingScreen(context),
    );
  }
}
