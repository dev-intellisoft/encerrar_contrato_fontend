import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/address_model.dart';
import '../models/solicitation_model.dart';
import '../models/service_model.dart';

class RegistrationServices {
  final Dio dio;
  RegistrationServices(this.dio);

  Future<String> getAgencyLogo(String agencyId) async {
    var response = await dio.get('/agency/logo/$agencyId');
    if (response.statusCode == 200) {
      return response.data;
    }
    throw Exception('Failed to get agency logo');
  }

  Future<Address> getCep(String cep) async {
    cep = cep.replaceAll(RegExp(r'\D'), '');
    var response = await Dio().get('https://viacep.com.br/ws/$cep/json/');
    if (response.data != null && response.data['erro'] != true) {
      return Address.fromViaCEP(response.data);
    }
    throw Exception('Failed to get CEP');
  }

  Future<List<Service>> getServices({required String type}) async {
    var response = await dio.get('/registration/services?type=$type');
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => Service.fromJson(e)).toList();
    }
    throw Exception('Failed to get services');
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
    var response = await dio.post(
      '/registration/${solicitation.agencyId}',
      data: data,
    );
    if (response.statusCode == 201) {
      return Solicitation.fromJson(response.data);
    }
    throw Exception('Failed to create solicitation');
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

    var response = await dio.post(
      "/transfer/${soliciation.agencyId}",
      data: data,
    );

    if (response.statusCode == 201) {
      return Solicitation.fromJson(response.data);
    }
    throw Exception("Failed to create solicitation");
  }
}
