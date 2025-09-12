import 'package:get/get.dart';
import 'package:encerrar_contrato/app/controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController());
  }
}
