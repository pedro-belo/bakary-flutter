import 'package:bakery/exception_handler.dart';
import 'package:bakery/models/product.dart';
import 'package:dio/dio.dart';

class ProductRepository {
  Dio http;

  ProductRepository(this.http);

  Future<void> delete(Product product) async {
    try {
      await http.delete("/product/${product.id}/");
    } on DioException catch (e) {
      throw MessageException(handleDioException(e));
    } catch (e) {
      throw MessageException(e.toString());
    }
  }

  Future<Product> create(Product product) async {
    try {
      final response = await http.post(
        "/product/",
        data: product.toJson(useId: false),
      );
      return Product.fromJson(response.data);
    } on DioException catch (e) {
      throw MessageException(handleDioException(e));
    } catch (e) {
      throw MessageException(e.toString());
    }
  }

  Future<List<Product>> getAll() async {
    try {
      final response = await http.get("/product/");
      List<dynamic> products = response.data;
      return products.map((product) => Product.fromJson(product)).toList();
    } on DioException catch (e) {
      throw MessageException(handleDioException(e));
    } catch (e) {
      throw MessageException(e.toString());
    }
  }
}
