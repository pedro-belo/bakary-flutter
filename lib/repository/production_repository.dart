import 'package:dio/dio.dart';
import 'package:bakery/exception_handler.dart';
import 'package:bakery/models/production.dart';

class ProductionRepository {
  Dio http;

  ProductionRepository(this.http);

  Future<List<Production>> getAll() async {
    try {
      final response = await http.get("/production/");
      List<dynamic> productions = response.data;
      return productions
          .map((production) => Production.fromJson(production))
          .toList();
    } on DioException catch (e) {
      throw MessageException(handleDioException(e));
    } catch (e) {
      throw MessageException(e.toString());
    }
  }

  Future<Production> create(Production production) async {
    try {
      final response = await http.post(
        "/production/",
        data: production.toJson(useId: false),
      );
      return Production.fromJson(response.data);
    } on DioException catch (e) {
      throw MessageException(handleDioException(e));
    } catch (e) {
      throw MessageException(e.toString());
    }
  }
}
