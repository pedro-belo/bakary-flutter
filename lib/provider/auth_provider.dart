import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bakery/api.dart';
import 'package:dio/dio.dart';

class AuthProviderData {
  String accessToken;
  String refreshToken;

  void Function() calledWhenRefreshTokenExpire;

  factory AuthProviderData.unauthenticated() {
    return AuthProviderData(
      accessToken: "",
      refreshToken: "",
      calledWhenRefreshTokenExpire: () {},
    );
  }

  AuthProviderData({
    required this.accessToken,
    required this.refreshToken,
    required this.calledWhenRefreshTokenExpire,
  });
}

final authProvider = NotifierProvider<AuthProvider, AuthProviderData>(
  () => AuthProvider(),
);

class AuthProvider extends Notifier<AuthProviderData> {
  @override
  AuthProviderData build() {
    return AuthProviderData.unauthenticated();
  }

  void clean() {
    state = AuthProviderData.unauthenticated();
  }

  Dio getAuthenticatedHttpClient() {
    if (state.accessToken.isEmpty) {
      throw "Call configure before using this method.";
    }
    final baseUrl = EnvironmentConfig.createFrom(getCurrentEnvironment());

    final http = Dio();
    http.options.baseUrl = baseUrl;
    http.options.contentType = Headers.jsonContentType;
    http.options.headers["Authorization"] = "Bearer ${state.accessToken}";

    http.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        switch (options.method) {
          case 'GET':
            options.validateStatus = (status) => status == HttpStatus.ok;
            break;
          case 'POST':
            options.validateStatus = (status) => status == HttpStatus.created;
            break;
          case 'DELETE':
            options.validateStatus = (status) => status == HttpStatus.noContent;
            break;
        }
        return handler.next(options);
      },
    ));

    return http;
  }

  Dio getUnauthenticatedHttpClient() {
    final http = Dio();
    http.options.baseUrl =
        EnvironmentConfig.createFrom(getCurrentEnvironment());
    return http;
  }

  void configure({
    required String accessToken,
    required String refreshToken,
    required void Function() calledWhenRefreshTokenExpire,
  }) {
    state = AuthProviderData(
      accessToken: accessToken,
      refreshToken: refreshToken,
      calledWhenRefreshTokenExpire: calledWhenRefreshTokenExpire,
    );
  }
}
