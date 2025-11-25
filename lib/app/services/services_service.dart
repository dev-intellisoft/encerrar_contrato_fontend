import 'package:dio/dio.dart';
import '../models/service_model.dart';

class ServicesService {
  ServicesService(this.dio);
  final Dio dio;
  Future<List<Service>> getServices() async {
    final response = await dio.get('/services');
    return (response.data as List).map((e) => Service.fromJson(e)).toList();
  }

  Future<void> removeService(Service service) async {
    var response = await dio.delete('/services/${service.id}');
    if (response.statusCode == 200) {
      return;
    }
  }
}
