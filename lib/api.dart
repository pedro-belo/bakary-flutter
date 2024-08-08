import 'package:dio/dio.dart';

String getCurrentEnvironment() {
  return "development";
}

class EnvironmentConfig {
  String baseUrl;
  EnvironmentConfig(this.baseUrl);

  static createFrom(String environment) {
    switch (environment) {
      case "development":
        return "http://localhost:8000";
      case "production":
        return "https://127.0.0.1";
      default:
        throw ArgumentError(environment);
    }
  }
}

Dio createBasicHttpEntryPoint() {
  final http = Dio();
  http.options.baseUrl = EnvironmentConfig.createFrom(getCurrentEnvironment());
  return http;
}
