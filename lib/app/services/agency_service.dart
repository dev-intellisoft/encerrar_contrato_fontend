import 'package:dio/dio.dart';
import '../models/agency_model.dart';
import '../models/service_model.dart';
import '../models/address_model.dart';
import '../models/solicitation_model.dart';
import 'dart:convert';

class AgencyService {
  final Dio dio;
  AgencyService(this.dio);

  Future<List<Agency>> getAll() async {
    var response = await dio.get('/agencies');
    if (response.statusCode == 200) {
      return (response.data as List).map((a) => Agency.fromJson(a)).toList();
    }
    throw Exception(response.data);
  }

  Future<Agency> create(Agency agency) async {
    FormData data;
    if (agency.fileBytes == null) {
      data = FormData.fromMap({
        "name": agency.name,
        "login": agency.login,
        "password": agency.password,
      });
    } else {
      data = FormData.fromMap({
        "files": [
          MultipartFile.fromBytes(
            agency.fileBytes!, // Uint8List
            filename: agency.fileName,
          ),
        ],
        "name": agency.name,
        "login": agency.login,
        "password": agency.password,
      });
    }

    final response = await dio.post('/agencies', data: data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Agency.fromJson(response.data);
    }

    throw Exception(response.data);
  }

  Future<Agency> update(String id, Agency agency) async {
    FormData data;
    if (agency.fileBytes == null) {
      data = FormData.fromMap({
        "name": agency.name,
        "login": agency.login,
        "password": agency.password,
      });
    } else {
      data = FormData.fromMap({
        "files": [
          MultipartFile.fromBytes(
            agency.fileBytes!, // Uint8List
            filename: agency.fileName,
          ),
        ],
        "name": agency.name,
        "login": agency.login,
        "password": agency.password,
      });
    }

    var response = await dio.put('/agencies/$id', data: data);
    if (response.statusCode == 200) {
      return Agency.fromJson(response.data);
    }
    throw Exception(response.data);
  }

  Future<Agency> delete(String id) async {
    var response = await dio.delete('/agencies/$id');
    if (response.statusCode == 200) {
      return Agency.fromJson(response.data);
    }

    throw Exception(response.data);
  }

  Future<Agency> getById(String id) async {
    var response = await this.dio.get('/agencies/$id');
    if (response.statusCode == 200) {
      return Agency.fromJson(response.data);
    }
    throw Exception(response.data);
  }

  Future<List<Service>> getServices({required String type}) async {
    var response = await dio.get('/registration/services?type=$type');
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => Service.fromJson(e)).toList();
    }
    throw Exception('Failed to get services');
  }

  Future<Address> getCep(String cep) async {
    cep = cep.replaceAll(RegExp(r'\D'), '');
    var response = await Dio().get('https://viacep.com.br/ws/$cep/json/');
    if (response.data != null && response.data['erro'] != true) {
      return Address.fromViaCEP(response.data);
    }
    throw Exception('Failed to get CEP');
  }

  Future<Solicitation> transfer({
    required Documents documents,
    required Solicitation soliciation,
  }) async {
    FormData data = FormData.fromMap({
      'payload': json.encode(soliciation.toJson()),
    });

    data.files.addAll([
      MapEntry(
        'document_photo',
        MultipartFile.fromBytes(
          documents.documentPhotoByte!,
          filename: documents.documentPhotoName,
        ),
      ),
      MapEntry(
        'photo_with_document',
        MultipartFile.fromBytes(
          documents.photoWithDocumentByte!,
          filename: documents.photoWithDocumentName,
        ),
      ),
      MapEntry(
        'last_invoice',
        MultipartFile.fromBytes(
          documents.lastInvoiceByte!,
          filename: documents.lastInvoiceName,
        ),
      ),
      MapEntry(
        'contract',
        MultipartFile.fromBytes(
          documents.contractByte!,
          filename: documents.contractName,
        ),
      ),
    ]);

    var response = await dio.post("/agency/transfer", data: data);

    if (response.statusCode == 201) {
      return Solicitation.fromJson(response.data);
    }
    throw Exception("Failed to create solicitation");
  }

  Future<Solicitation> register(Solicitation solicitation) async {
    var data = json.encode(solicitation.toJson());
    var response = await dio.post('/agency/registration', data: data);
    if (response.statusCode == 201) {
      return Solicitation.fromJson(response.data);
    }
    throw Exception('Failed to create solicitation');
  }
}
