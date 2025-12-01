import 'package:dio/dio.dart';
import '../models/service_model.dart';

class ServicesService {
  ServicesService(this.dio);
  final Dio dio;
  Future<List<Service>> getServices() async {
    try {
      final response = await dio.get('/services');
      return (response.data as List).map((e) => Service.fromJson(e)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Service> removeService(String id) async {
    try {
      var response = await dio.delete('/services/$id');
      if (response.statusCode == 200) {
        return Service.fromJson(response.data);
      }
      throw Exception("Erro ao remover o serviço.");
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Service> updateServices(Service s) async {
    try {
      final response = await dio.put('/services/${s.id}', data: s.toJson());
      if (response.statusCode == 200) {
        return Service.fromJson(response.data);
      }
      throw Exception("Erro ao atualizar o serviço.");
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Service> createService(Service s) async {
    try {
      final response = await dio.post('/services', data: s.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Service.fromJson(response.data);
      }
      throw Exception("Erro ao criar serviço.");
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
