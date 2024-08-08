import 'package:bakery/models/product.dart';
import 'package:bakery/models/production.dart';
import 'package:bakery/provider/product_provider.dart';
import 'package:bakery/provider/production_provider.dart';
import 'package:bakery/screen/production_create_screen.dart';
import 'package:bakery/utils.dart' as utils;
import 'package:bakery/widget/error_retry.dart';
import 'package:bakery/widget/loading_data.dart';
import 'package:bakery/widget/production/list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ProductionScreen extends ConsumerWidget {
  const ProductionScreen({super.key});

  void navigateToCreateProduction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const ProductionCreateScreen();
        },
      ),
    );
  }

  Widget _buildMainScreen(
    BuildContext context,
    List<Product> products,
    List<Production> productions,
  ) {
    final currYear = DateTime.now().year;
    final productionThisYear = productions
        .where((production) => production.date.year == currYear)
        .toList();

    return Scaffold(
      appBar: utils.createAppBar(context, title: "Produção", actions: [
        IconButton(
          onPressed: () => navigateToCreateProduction(context),
          icon: const Icon(Icons.add),
        )
      ]),
      body: ProductionList(
        production: productionThisYear,
        products: products,
      ),
    );
  }

  Widget _buildLoadingScreen(BuildContext context, String description) {
    return Scaffold(
      appBar: utils.createAppBar(context, title: "Aguarde"),
      body: LoadingData(
        description: description,
      ),
    );
  }

  Widget _buildErrorScreen({
    required BuildContext context,
    required void Function() onTryAgain,
    required Object error,
  }) {
    return Scaffold(
      appBar: utils.createAppBar(context, title: "Erro"),
      body: ErrorRetry(
        message: error.toString(),
        onTryAgain: onTryAgain,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final production = ref.watch(productionProvider);
    final products = ref.watch(productProvider);

    return products.when(
      skipLoadingOnRefresh: false,
      skipLoadingOnReload: false,
      data: (productsData) {
        return production.when(
          skipLoadingOnRefresh: false,
          skipLoadingOnReload: false,
          data: (productionData) {
            return _buildMainScreen(
              context,
              productsData.all(),
              productionData.all(),
            );
          },
          error: (error, stackTrace) => _buildErrorScreen(
            context: context,
            error: error,
            onTryAgain: () {
              ref.invalidate(productionProvider);
            },
          ),
          loading: () => _buildLoadingScreen(context, "Carregando Produção"),
        );
      },
      error: (error, stackTrace) => _buildErrorScreen(
        context: context,
        error: error,
        onTryAgain: () {
          ref.invalidate(productProvider);
        },
      ),
      loading: () => _buildLoadingScreen(context, "Carregando Produtos"),
    );
  }
}
