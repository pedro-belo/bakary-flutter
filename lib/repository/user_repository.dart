import 'dart:io';
import 'package:bakery/models/user.dart';
import 'package:dio/dio.dart';
import 'package:bakery/exception_handler.dart';

class UserRepository {
  Dio http;

  UserRepository(this.http);

  Future<String> register(String username, String password) async {
    http.options.validateStatus = (status) => status == HttpStatus.created;
    http.options.contentType = Headers.jsonContentType;

    try {
      final response = await http.post(
        "/user/create/",
        data: {
          'username': username,
          'password': password,
        },
      );

      Map<String, dynamic> responseData = response.data;
      return responseData["detail"];
    } on DioException catch (e) {
      throw MessageException(handleDioException(e));
    } catch (e) {
      throw MessageException(e.toString());
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    http.options.contentType = Headers.formUrlEncodedContentType;
    http.options.validateStatus = (status) => status == HttpStatus.ok;

    try {
      final response = await http.post(
        "/auth/obtain-token/",
        data: {
          'username': username,
          'password': password,
        },
      );

      final authData = response.data;

      return {
        "accessToken": authData["access_token"],
        "refreshToken": authData["access_token"],
        "user": User.fromJson(authData["user"])
      };
    } on DioException catch (e) {
      throw MessageException(handleDioException(e));
    } catch (e) {
      throw MessageException(e.toString());
    }
  }
}
