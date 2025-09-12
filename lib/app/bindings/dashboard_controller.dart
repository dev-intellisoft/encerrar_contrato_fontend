import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../services/solicitation_services.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SolicitationServices(Get.find<Dio>()));
    Get.lazyPut(() => DashboardController());
  }
}