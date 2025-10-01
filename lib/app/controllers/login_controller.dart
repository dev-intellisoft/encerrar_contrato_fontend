import 'package:encerrar_contrato/app/models/access_token_model.dart';
import 'package:encerrar_contrato/app/models/user_model.dart';
import 'package:get/get.dart';
import 'package:encerrar_contrato/app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

import '../services/login_services.dart';

class LoginController extends GetxController {
  final LoginServices service = Get.find<LoginServices> ();

  Rx<User> user = User().obs;
  Rx<AccessToken> accessToken =  AccessToken().obs;
  Future<void> login() async {
    try {
      accessToken.value = await service.login(user.value.email!, user.value.password!);
      GetStorage().write('token', accessToken.value.toJson());
      user.value = await service.me();
      GetStorage().write('user', user.value.toJson());
      if(user.value.agency == 'encerrar' || user.value.agency == '') {
        return Get.offAllNamed(Routes.DASHBOARD);
      }
      return Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> register() async {
    Get.toNamed(Routes.REGISTER);
  }

  Future<void> checkSession() async {
    try {
      user.value = await service.checkSession();
      if (!(user.value.id! != "")) {
        throw Exception('No session');
      }
      if(user.value.agency == 'encerrar' || user.value.agency == '') {
        return Get.offAllNamed(Routes.DASHBOARD);
      }
      return Get.offAllNamed(Routes.HOME);
    } catch(e) {
      GetStorage().remove('token');
      Get.snackbar('Error', e.toString());
    }
  }
}
