import 'package:get/get.dart';
import '../models/service_model.dart';
import '../services/services_service.dart';

class ServicesController extends GetxController {
  ServicesService servicesService = Get.find<ServicesService>();
  RxList<Service> services = <Service>[].obs;
  Rx<Service> service = Service().obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getServices() async {
    try {
      services.value = await servicesService.getServices();
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeService(String id) async {
    try {
      final response = await servicesService.removeService(id);
      await getServices();
      Get.back();
      Get.snackbar('Sucesso', 'Serviço removido com sucesso!');
    } catch (e) {
      Get.snackbar('Erro', e.toString());
    }
  }

  Future<void> save() async {
    try {
      if (service.value.id != null) {
        final response = await servicesService.updateServices(service.value);
        await getServices();
        Get.back();
        Get.snackbar('Success', 'Serviço criado com sucesso!');
      } else {
        final response = await servicesService.createService(service.value);
        await getServices();
        Get.back();
        Get.snackbar('Success', 'Serviço criado com sucesso!');
      }
    } catch (e) {
      Get.snackbar('Erro', e.toString());
    }
  }
}
