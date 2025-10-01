import 'package:dio/dio.dart';
import 'package:encerrar_contrato/app/models/access_token_model.dart';
import 'package:encerrar_contrato/app/routes/app_pages.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var token = GetStorage().read('token');
    if(token != null) {
      AccessToken accessToken = AccessToken.fromJson(token);
      options.headers['Authorization'] = 'Bearer ${accessToken.accessToken}';
      options.baseUrl = '${dotenv.env['API_URL']}';
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if(err.response?.data['error'] == 'Unauthorized') {
      GetStorage().remove('token');
      Get.snackbar('Erro', 'Sessão expirada');
      Get.offAllNamed(Routes.LOGIN);
    }

    Get.snackbar('Erro', err.response?.data);
    // Tratar erros globais
    super.onError(err, handler);
  }
}


class DioProvider {
  static Dio createDio() {
    print(dotenv.env['API_URL']);
    final dio = Dio(BaseOptions(baseUrl: '${dotenv.env['API_URL']}'));
    dio.interceptors.add(ApiInterceptor());
    return dio;
  }
}