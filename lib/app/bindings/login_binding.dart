import 'package:dio/dio.dart';
import 'package:encerrar_contrato/app/services/login_services.dart';
import 'package:get/get.dart';
import 'package:encerrar_contrato/app/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginServices>(() => LoginServices(Get.find<Dio>()));
    Get.lazyPut<LoginController>(() => LoginController());
  }
}