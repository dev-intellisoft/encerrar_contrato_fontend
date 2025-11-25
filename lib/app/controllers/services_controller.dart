import 'package:get/get.dart';
import '../models/service_model.dart';
import '../services/services_service.dart';

class ServicesController extends GetxController {
  ServicesService servicesService = Get.find<ServicesService>();
  RxList<Service> services = <Service>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getServices() async {
    services.value = await servicesService.getServices();
  }

  Future<void> removeService(Service service) async {
    await servicesService.removeService(service);
    services.remove(service);
  }
}
