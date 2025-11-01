import 'package:dio/dio.dart';
import 'package:encerrar_contrato/app/services/payment_service.dart';
import 'package:get/get.dart';
import 'package:encerrar_contrato/app/controllers/register_controller.dart';

import '../services/registration_services.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RegistrationServices(Get.find<Dio>()));
    Get.put(PaymentService(Get.find<Dio>()));
    Get.put(RegisterController());
  }
}
