
import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/address_model.dart';
import '../models/solicitation_model.dart';

class RegistrationServices {
  final Dio dio;
  RegistrationServices(this.dio);
  Future<Address> getCep(String cep) async {
    cep = cep.replaceAll(RegExp(r'\D'), '');
    var response = await Dio().get('https://viacep.com.br/ws/$cep/json/');
    if (response.data != null && response.data['erro'] != true) {
      return Address.fromViaCEP(response.data);
    }
    throw Exception('Failed to get CEP');
  }
  Future<Solicitation> createSolicitation(Solicitation solicitation) async {
    var data = json.encode(solicitation.toJson());
    var response = await dio.post('/solicitations', data: data);
    if (response.statusCode == 201) {
      return Solicitation.fromJson(response.data);
    }
    throw Exception('Failed to create solicitation');
  }

  Future<Solicitation> register(Solicitation solicitation) async {
    var data = json.encode(solicitation.toJson());
    var response = await dio.post('/registration', data: data);
    if (response.statusCode == 201) {
      print(response.data);
      return Solicitation.fromJson(response.data);
    }
    throw Exception('Failed to create solicitation');
  }
}