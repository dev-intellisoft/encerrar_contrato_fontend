import 'package:dio/dio.dart';
import '../models/agency_model.dart';

class AgencyService {
  // final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/agencies'));
  final Dio dio;
  AgencyService(this.dio);

  Future<List<Agency>> getAll() async {
    final response = await this.dio.get('/agencies');
    return (response.data as List).map((a) => Agency.fromJson(a)).toList();
  }

  Future<Agency> create(Agency agency) async {
    final response = await this.dio.post('/agencies', data: agency.toJson());
    return Agency.fromJson(response.data);
  }

  Future<Agency> update(String id, Agency agency) async {
    final response = await this.dio.put('/agencies/$id', data: agency.toJson());
    return Agency.fromJson(response.data);
  }

  Future<void> delete(String id) async {
    await this.dio.delete('/agencies/$id');
  }

  Future<Agency> getById(String id) async {
    final response = await this.dio.get('/agencies/$id');
    return Agency.fromJson(response.data);
  }
}