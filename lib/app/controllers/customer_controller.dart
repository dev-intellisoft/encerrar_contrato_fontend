import 'package:get/get.dart';
import 'package:encerrar_contrato/app/models/customer_model.dart';

class CustomerController extends GetxController {
  RxList<Customer> customers = <Customer>[].obs;
  @override
  void onInit() {
    super.onInit();
  }
}
