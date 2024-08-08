import 'package:dio/dio.dart';
import 'package:bakery/repository/user_repository.dart';
import 'package:bakery/repository/product_repository.dart';
import 'package:bakery/repository/production_repository.dart';

class Repository {
  final Dio http;

  Repository(this.http);

  ProductRepository get product => ProductRepository(http);

  ProductionRepository get production => ProductionRepository(http);

  UserRepository get user => UserRepository(http);
}
