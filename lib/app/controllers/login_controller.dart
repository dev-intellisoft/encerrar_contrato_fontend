import 'package:encerrar_contrato/app/models/access_token_model.dart';
import 'package:encerrar_contrato/app/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:encerrar_contrato/app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

import '../services/login_services.dart';

class LoginController extends GetxController {
  final LoginServices service = Get.find<LoginServices>();

  Rx<User> user = User().obs;
  Rx<AccessToken> accessToken = AccessToken().obs;
  bool _sessionCheckInProgress = false;
  bool _sessionChecked = false;

  @override
  void onInit() {
    super.onInit();
    checkSession();

    print('=================>LoginController onInit');
  }

  @override
  void onClose() {
    super.onClose();
    print('=================>LoginController onClose');
  }

  @override
  void onReady() {
    super.onReady();
    print('=================>LoginController onReady');
  }

  Future<void> login() async {
    try {
      final email = (user.value.email ?? '').trim();
      final password = user.value.password ?? '';

      if (email.isEmpty || password.isEmpty) {
        Get.snackbar(
          'Dados obrigatórios',
          'Informe seu e-mail e sua senha para continuar.',
        );
        return;
      }

      accessToken.value = await service.login(
        email,
        password,
      );
      GetStorage().write('token', accessToken.value.toJson());
      user.value = await service.me();
      GetStorage().write('user', user.value.toJson());
      if (user.value.agency == 'encerrar' || user.value.agency == '') {
        return Get.offAllNamed(Routes.DASHBOARD);
      }
      return Get.offAllNamed(Routes.HOME);
    } catch (e) {
      if (e is! DioException) {
        Get.snackbar(
          'Não foi possível entrar',
          'Confira seus dados e tente novamente.',
        );
      }
    }
  }

  Future<void> register() async {
    Get.toNamed(Routes.REGISTER);
  }

  Future<void> checkSession() async {
    if (_sessionCheckInProgress || _sessionChecked) return;
    _sessionCheckInProgress = true;
    try {
      user.value = await service.checkSession();
      final userId = (user.value.id ?? '').trim();
      if (userId.isEmpty) {
        throw Exception('No session');
      }
      if (user.value.agency == 'encerrar' || user.value.agency == '') {
        _sessionChecked = true;
        return Get.offAllNamed(Routes.DASHBOARD);
      }
      _sessionChecked = true;
      return Get.offAllNamed(Routes.HOME);
    } catch (e) {
      GetStorage().remove('token');
      _sessionChecked = true;
    } finally {
      _sessionCheckInProgress = false;
    }
  }
}
