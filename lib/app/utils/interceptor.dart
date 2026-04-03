import 'package:dio/dio.dart';
import 'package:encerrar_contrato/app/models/access_token_model.dart';
import 'package:encerrar_contrato/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'api_url.dart';

class ApiInterceptor extends Interceptor {
  String _defaultMessageForStatus(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Não foi possível concluir a ação. Revise os dados e tente novamente.';
      case 401:
        return 'Sua sessão expirou. Faça login novamente para continuar.';
      case 403:
        return 'Você não tem permissão para realizar esta ação.';
      case 404:
        return 'Não encontramos a informação solicitada.';
      case 409:
        return 'Já existe um cadastro com esses dados.';
      case 422:
        return 'Alguns dados precisam ser corrigidos antes de continuar.';
      case 500:
      case 502:
      case 503:
        return 'O servidor está indisponível no momento. Tente novamente em instantes.';
      default:
        return 'Ocorreu um erro inesperado. Tente novamente.';
    }
  }

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

    return '';
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = GetStorage().read('token');
    final baseUrl = resolveApiBaseUrl();
    if (token != null) {
      final accessToken = AccessToken.fromJson(token);
      options.headers['Authorization'] = 'Bearer ${accessToken.accessToken}';
      if (baseUrl.isNotEmpty) {
        options.baseUrl = baseUrl;
      }
    } else if (baseUrl.isNotEmpty) {
      options.baseUrl = baseUrl;
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final data = err.response?.data;
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;
    final isSessionCheck = path.contains('/users/me');
    final hasToken = GetStorage().read('token') != null;
    final serverMessage = _errorMessage(data).trim();
    final message =
        serverMessage.isNotEmpty
            ? serverMessage
            : _defaultMessageForStatus(statusCode);

    if (statusCode == 401 ||
        (data is Map<String, dynamic> && data['error'] == 'Unauthorized')) {
      GetStorage().remove('token');
      if (!isSessionCheck && hasToken) {
        Get.snackbar('Sessão expirada', _defaultMessageForStatus(401));
      }
      Get.offAllNamed(Routes.LOGIN);
      return super.onError(err, handler);
    }

    if (!(isSessionCheck && !hasToken)) {
      Get.snackbar('Atenção', message);
    }
    super.onError(err, handler);
  }
}

class DioProvider {
  static Dio createDio() {
    final baseUrl = resolveApiBaseUrl();
    final dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.interceptors.add(ApiInterceptor());
    return dio;
  }
}
