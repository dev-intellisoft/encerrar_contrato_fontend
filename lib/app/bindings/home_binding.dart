import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:encerrar_contrato/app/controllers/home_controller.dart';
import 'package:encerrar_contrato/app/services/solicitation_services.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SolicitationServices(Get.find<Dio>()));
    Get.lazyPut(() => HomeController());
  }
}
