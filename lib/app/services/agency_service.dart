import 'package:dio/dio.dart';
import '../models/agency_model.dart';

class AgencyService {
  final Dio dio;
  AgencyService(this.dio);

  Future<List<Agency>> getAll() async {
    var response = await dio.get('/agencies');
    if(response.statusCode == 200) {
      return (response.data as List).map((a) => Agency.fromJson(a)).toList();
    }
    throw Exception(response.data);
  }

  Future<Agency> create(Agency agency) async {
    FormData formData = FormData.fromMap({
      'name': agency.name,
      'login':agency.login,
      'password': agency.password,
      'file': await MultipartFile.fromFile(agency.file!.path,
          filename: agency.file!.path.split('/').last),
    });
    // var response = await dio.post('/agencies', data: agency.toJson());
    var response = await dio.post('/agencies', data: formData);
    print(response);
    if(response.statusCode == 200 || response.statusCode == 201){
      return Agency.fromJson(response.data);
    }
    throw Exception(response.data);
  }

  Future<Agency> update(String id, Agency agency) async {
    var response = await dio.put('/agencies/$id', data: agency.toJson());
    if(response.data == 200){
      return Agency.fromJson(response.data);
    }
    throw Exception(response.data);
  }

  Future<Agency> delete(String id) async {
    var response = await dio.delete('/agencies/$id');
    if(response.statusCode == 200) {
       return Agency.fromJson(response.data);
    }

    throw Exception(response.data);
  }

  Future<Agency> getById(String id) async {
    var response = await this.dio.get('/agencies/$id');
    if(response.statusCode == 200) {
      return Agency.fromJson(response.data);
    }
    throw Exception(response.data);
  }
}