import 'package:bakery/models/product.dart';
import 'package:bakery/models/production.dart';
import 'package:bakery/provider/product_provider.dart';
import 'package:bakery/provider/production_provider.dart';
import 'package:bakery/utils.dart' as utils;
import 'package:bakery/widget/error_retry.dart';
import 'package:bakery/widget/loading_data.dart';
import 'package:bakery/widget/production/form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ProductionCreateScreen extends ConsumerWidget {
  const ProductionCreateScreen({super.key});

  Future<void> onCreateProduction(
    Production production,
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      await ref.read(productionProvider.notifier).create(production);
      if (context.mounted) {
        utils.snackBarSuccess(context, message: "Produção criada.");
        Navigator.pop(context);
      }
    } catch (err) {
      utils.snackBarError(context, message: err.toString());
    }
  }

  Widget _buildMainScreen(
      BuildContext context, WidgetRef ref, List<Product> products) {
    return Scaffold(
      appBar: utils.createAppBar(context, title: "Nova Produção"),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ProductionForm(
          products: products,
          onCreateProduction: (production) async {
            await onCreateProduction(production, context, ref);
          },
        ),
      ),
    );
  }

  Widget _buildErrorScreen(BuildContext context, WidgetRef ref, Object error) {
    return Scaffold(
      appBar: utils.createAppBar(context, title: "Erro"),
      body: ErrorRetry(
        message: error.toString(),
        onTryAgain: () {
          ref.invalidate(productProvider);
        },
      ),
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      appBar: utils.createAppBar(context, title: "Aguarde"),
      body: const LoadingData(
        description: "Carregando Produtos",
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.read(productProvider);

    return products.when(
      data: (productsData) => _buildMainScreen(
        context,
        ref,
        productsData.all(),
      ),
      error: (error, stackTrace) => _buildErrorScreen(context, ref, error),
      loading: () => _buildLoadingScreen(context),
    );
  }
}
