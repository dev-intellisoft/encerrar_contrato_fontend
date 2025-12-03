import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../models/address_model.dart';
import '../models/solicitation_model.dart';
import '../models/service_model.dart';

class RegistrationServices {
  final Dio dio;
  RegistrationServices(this.dio);

  Future<String> getAgencyLogo(String agencyId) async {
    // Dio _dio = Dio();
    // var response = await _dio.get('/agency/logo/$agencyId');
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
    required PlatformFile documentPhoto,
    required PlatformFile photoWithDocument,
    required PlatformFile lastInvoice,
    required PlatformFile contract,
    required Solicitation soliciation,
  }) async {
    // "document_photo", "photo_with_document", "last_invoice", "contract"
    var data = FormData.fromMap({
      'files': [
        await MultipartFile.fromFile(
          '/Users/wellington/Documents/photo.jpg',
          filename: 'photo.jpg',
        ),
        await MultipartFile.fromFile(
          '/Users/wellington/Documents/photo.jpg',
          filename: 'photo.jpg',
        ),
        await MultipartFile.fromFile(
          '/Users/wellington/Documents/photo.jpg',
          filename: 'photo.jpg',
        ),
        await MultipartFile.fromFile(
          '/Users/wellington/Documents/photo.jpg',
          filename: 'photo.jpg',
        ),
        // await MultipartFile.fromFile(
        //   documentPhoto.path!,
        //   filename: documentPhoto.name,
        // ),
        // await MultipartFile.fromFile(
        //   photoWithDocument.path!,
        //   filename: photoWithDocument.name,
        // ),
        // await MultipartFile.fromFile(
        //   lastInvoice.path!,
        //   filename: lastInvoice.name,
        // ),
        // await MultipartFile.fromFile(contract.path!, filename: contract.name),
      ],
      'payload': json.encode(soliciation.toJson()),
    });
    var response = await dio.post("/transfer", data: data);
    if (response.statusCode == 201) {
      print(response.data);
      return Solicitation.fromJson(response.data);
    }
    throw Exception("Failed to create solicitation");
  }
}
