import 'package:bakery/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bakery/repository/repository.dart';
import 'package:bakery/provider/auth_provider.dart';
import 'package:bakery/exception_handler.dart';

class ProductData {
  late final List<Product> _products;

  ProductData(List<Product> products) : _products = List.unmodifiable(products);

  List<Product> all() {
    return _products;
  }
}

final productProvider = AsyncNotifierProvider<ProductNotifier, ProductData>(
  () => ProductNotifier(),
);

class ProductNotifier extends AsyncNotifier<ProductData> {
  @override
  Future<ProductData> build() async {
    final http = ref.read(authProvider.notifier).getAuthenticatedHttpClient();
    final repository = Repository(http);
    final products = await repository.product.getAll();
    return ProductData(products);
  }

  /// Create a new product
  Future<Product> create(Product product) async {
    if (state.value == null) {
      throwInvalidProviderState(
        provider: "product",
        detail: "Cannot create product",
      );
    }

    final http = ref.read(authProvider.notifier).getAuthenticatedHttpClient();
    final repository = Repository(http);
    final newProduct = await repository.product.create(product);

    state = AsyncValue.data(
      ProductData(
        [...state.value!.all(), newProduct],
      ),
    );

    return newProduct;
  }

  /// Delete a product
  Future<void> delete(Product product) async {
    if (state.value == null) {
      throwInvalidProviderState(
        provider: "product",
        detail: "Cannot delete product",
      );
    }

    final http = ref.read(authProvider.notifier).getAuthenticatedHttpClient();
    final repository = Repository(http);
    final currentProducts = state.value!.all();

    await repository.product.delete(product);

    final newProductList = currentProducts
        .where(
          (p) => p.id != product.id,
        )
        .toList();

    state = AsyncValue.data(ProductData(newProductList));
  }

  /// clean state, mainly used after user logout.
  void clean() {
    state = AsyncData(ProductData([]));
  }
}
