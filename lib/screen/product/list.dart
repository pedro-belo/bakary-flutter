import 'package:bakery/models/product.dart';
import 'package:bakery/provider/product_provider.dart';
import 'package:bakery/screen/product/create.dart';
import 'package:bakery/screen/product/detail.dart';
import 'package:bakery/utils.dart' as utils;
import 'package:bakery/widget/error_retry.dart';
import 'package:bakery/widget/loading_data.dart';
import 'package:bakery/widget/product/list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  // navigate to the product details screen
  void navigateToProductDetail(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product),
      ),
    );
  }

  // navigate to the product create screen
  void navigateToCreateProduct(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext ctx) {
          return const CreateProductScreen();
        },
      ),
    );
  }

  Widget _buildMainScreen(BuildContext context, List<Product> products) {
    return Scaffold(
      appBar: utils.createAppBar(
        context,
        title: "Produtos",
        actions: [
          IconButton(
            onPressed: () => navigateToCreateProduct(context),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ProductList(
          products,
          onSelectProduct: (Product product) {
            navigateToProductDetail(context, product);
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
    final products = ref.watch(productProvider);

    return products.when(
      skipLoadingOnRefresh: false,
      skipLoadingOnReload: false,
      data: (productsData) => _buildMainScreen(context, productsData.all()),
      loading: () => _buildLoadingScreen(context),
      error: (error, stackTrace) => _buildErrorScreen(context, ref, error),
    );
  }
}
