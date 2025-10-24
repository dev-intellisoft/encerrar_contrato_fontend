import 'package:get/get.dart';
import '../models/agency_model.dart';
import '../services/agency_service.dart';

class AgencyController extends GetxController {
  final AgencyService services = Get.find<AgencyService>();

  var agencies = <Agency>[].obs;
  var isLoading = false.obs;

  Future<void> fetchAgencies() async {
    isLoading.value = true;
    agencies.value = await services.getAll();
    isLoading.value = false;
  }

  Future<void> addAgency(Agency agency) async {
    await services.create(agency);
    await fetchAgencies();
  }

  Future<void> updateAgency(String id, Agency agency) async {
    await services.update(id, agency);
    await fetchAgencies();
  }

  Future<void> deleteAgency(String id) async {
    await services.delete(id);
    await fetchAgencies();
  }
}
