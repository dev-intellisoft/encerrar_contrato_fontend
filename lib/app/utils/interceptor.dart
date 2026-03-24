import 'package:dio/dio.dart';
import 'package:encerrar_contrato/app/models/access_token_model.dart';
import 'package:encerrar_contrato/app/routes/app_pages.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ApiInterceptor extends Interceptor {
  String _errorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      final details = data['details'];

      if (error is String && details is String && details.isNotEmpty) {
        return '$error: $details';
      }
      if (error is String) {
        return error;
      }
      if (details is String) {
        return details;
      }
      return data.toString();
    }

    if (data is String && data.isNotEmpty) {
      return data;
    }

    return 'Erro inesperado';
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = GetStorage().read('token');
    if (token != null) {
      final accessToken = AccessToken.fromJson(token);
      options.headers['Authorization'] = 'Bearer ${accessToken.accessToken}';
      options.baseUrl = '${dotenv.env['API_URL']}';
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final data = err.response?.data;
    final message = _errorMessage(data);

    if (data is Map<String, dynamic> && data['error'] == 'Unauthorized') {
      GetStorage().remove('token');
      Get.snackbar('Erro', 'Sessao expirada');
      Get.offAllNamed(Routes.LOGIN);
    }

    Get.snackbar('Erro', message);
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
