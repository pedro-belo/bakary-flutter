import 'dart:async';
import 'package:bakery/provider/auth_provider.dart';
import 'package:bakery/models/production.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bakery/repository/repository.dart';
import 'package:bakery/exception_handler.dart';

class ProductionData {
  final List<Production> _production;

  ProductionData(List<Production> production)
      : _production = List.unmodifiable(production);

  List<Production> getProductionsForProduct(int productId) {
    return _production.where((p) => p.productId == productId).toList();
  }

  List<Production> all() {
    return _production;
  }
}

final productionProvider =
    AsyncNotifierProvider<ProductionProvider, ProductionData>(
  () => ProductionProvider(),
);

class ProductionProvider extends AsyncNotifier<ProductionData> {
  @override
  Future<ProductionData> build() async {
    final http = ref.read(authProvider.notifier).getAuthenticatedHttpClient();
    final repository = Repository(http);
    final productions = await repository.production.getAll();
    return ProductionData(productions);
  }

  /// Create a new production
  Future<Production> create(Production production) async {
    if (state.value == null) {
      throwInvalidProviderState(
        provider: "production",
        detail: "Cannot create production",
      );
    }

    final http = ref.read(authProvider.notifier).getAuthenticatedHttpClient();
    final repository = Repository(http);
    final newProduction = await repository.production.create(production);

    state = AsyncData(
      ProductionData(
        [...state.value!.all(), newProduction],
      ),
    );

    return newProduction;
  }

  /// called after deleting a product to update the UI
  void syncStateAfterProductDeletion(int productId) {
    if (state.value == null) {
      throwInvalidProviderState(
        provider: "production",
        detail: "State cannot be updated because it is null",
      );
    }

    final currentProduction = state.value!.all();

    state = AsyncData(
      ProductionData(
        currentProduction
          ..where((production) => production.productId != productId).toList(),
      ),
    );
  }

  /// clean state, mainly used after user logout.
  void clean() {
    state = AsyncData(
      ProductionData([]),
    );
  }
}
