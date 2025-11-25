import 'package:get/get.dart';
import '../controllers/services_controller.dart';
import '../services/services_service.dart';
import 'package:dio/dio.dart';

class ServicesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicesService>(() => ServicesService(Get.find<Dio>()));
    Get.lazyPut<ServicesController>(() => ServicesController());
  }
}
