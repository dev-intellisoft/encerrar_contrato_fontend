import 'package:dio/dio.dart';
import 'package:encerrar_contrato/app/controllers/agency_controller.dart';
import 'package:encerrar_contrato/app/services/agency_service.dart';
import 'package:get/get.dart';

class AgenciesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AgencyService(Get.find<Dio>()));
    Get.lazyPut<AgencyController>(() => AgencyController());
  }
}
