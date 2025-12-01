import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<String?> getAvatar() async {
  try {
    var token = GetStorage().read('token');
    if (token != null) {
      Map<String, dynamic> decoded = JwtDecoder.decode(token['access_token']);
      if (decoded['sub'] == null) {
        throw Exception('Invalid JWT token');
      }
      Map<String, dynamic> sub = jsonDecode(decoded['sub']);
      return sub['Avatar'];
    }
  } catch (e) {
    print(e);
    return '';
  }
}

//deprecated
Future<String?> getAgency() async {
  try {
    var token = GetStorage().read('token');
    if (token != null) {
      Map<String, dynamic> decoded = JwtDecoder.decode(token['access_token']);
      if (decoded['sub'] == null) {
        throw Exception('Invalid JWT token');
      }
      Map<String, dynamic> sub = jsonDecode(decoded['sub']);
      return sub['Agency'];
    }
  } catch (e) {
    print(e);
    return '';
  }
}
