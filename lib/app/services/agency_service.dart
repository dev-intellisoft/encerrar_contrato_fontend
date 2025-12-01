import 'package:dio/dio.dart';
import '../models/agency_model.dart';

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
}
