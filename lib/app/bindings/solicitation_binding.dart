import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../controllers/solicitation_controller.dart';
import '../services/solicitation_services.dart';

class SolicitationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SolicitationController());
    Get.put(SolicitationServices(Get.find<Dio>()));
  }
}