import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:encerrar_contrato/app/models/address_model.dart';

import '../models/solicitation_model.dart';

class SolicitationServices {
  final Dio dio;
  SolicitationServices(this.dio);
  Future<List<Solicitation>> getSolicitations() async {
    var response = await dio.get('/solicitations');

    if(response.statusCode == 200) {
      return (response.data as List).map((e) => Solicitation.fromJson(e)).toList();
    }
    return <Solicitation>[];
  }
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
  Future<Solicitation> startSolicitation(String id) async {
    var response = await dio.put('/solicitations/${id}/start');
    if (response.statusCode == 200) {
      print(response.data);
      return Solicitation.fromJson(response.data);
    }
    throw Exception('Failed to start solicitation');
  }
  Future<Solicitation> endSolicitation(String id) async {
    var response = await dio.put('/solicitations/${id}/end');
    if (response.statusCode == 200) {
      return Solicitation.fromJson(response.data);
    }
    throw Exception('Failed to end solicitation');
  }
}