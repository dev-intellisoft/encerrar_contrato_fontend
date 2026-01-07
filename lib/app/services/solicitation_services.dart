import 'dart:convert';
import 'package:html/parser.dart' as parser;

import 'package:dio/dio.dart';
import 'package:encerrar_contrato/app/models/address_model.dart';
import 'dart:typed_data';
import '../models/solicitation_model.dart';

class SolicitationServices {
  final Dio dio;
  SolicitationServices(this.dio);
  Future<List<Solicitation>> getSolicitations() async {
    var response = await dio.get('/solicitations');

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((e) => Solicitation.fromJson(e))
          .toList();
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

  Future<Solicitation> sendEmail(String email, String name) async {
    var response = await dio.post(
      '/solicitations/send-email',
      data: {'email': email, 'name': name},
    );
    if (response.statusCode == 200) {
      return Solicitation.fromJson(response.data);
    }
    throw Exception('Failed to send email');
  }

  Future<List<String>> listDocument(String id) async {
    var result = <String>[];
    var response = await dio.get('/documents/${id}');

    if (response.statusCode == 200) {
      var document = parser.parse(response.data);
      var links = document.querySelectorAll('a');
      for (var link in links) {
        result.add(link.attributes['href']!);
      }
      return result;
    }
    throw Exception('Failed to list documents');
  }

  Future<Uint8List> getDocument(String path) async {
    var response = await dio.get(path);
    if (response.statusCode == 200) {
      return response.data;
    }
    throw Exception('Failed to get document');
  }
}
