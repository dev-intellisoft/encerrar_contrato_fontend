import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../models/access_token_model.dart';
import 'package:dio/dio.dart';

import '../models/user_model.dart';

class LoginServices {
  final Dio dio;
  LoginServices(this.dio);

  Future<AccessToken> login(String email, String password) async {
    String token = base64Encode('encerrar:contract123'.codeUnits);

    var data = FormData.fromMap({
      'grant_type': 'password',
      'username': email,
      'password': password,
    });
    var response = await dio.post('/token', data:data, options: Options(headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Basic $token'
    }));
    if(response.statusCode == 200) {
      return AccessToken.fromJson(response.data);
    }
    throw Exception('Failed to login');
  }

  Future<User> checkSession() async {
    var token = await GetStorage().read('token');
    if(token == null) {
      throw Exception('No session');
    }
    AccessToken accessToken = AccessToken.fromJson(token);
    var response = await dio.get('/users/me', options: Options(headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ${accessToken.accessToken}'
    }));
    if(response.statusCode == 200) {
      return User.fromJson(response.data);
    }
    throw Exception('Failed to check session');
  }
}