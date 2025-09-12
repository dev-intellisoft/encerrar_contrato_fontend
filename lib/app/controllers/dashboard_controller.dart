
import 'package:encerrar_contrato/app/models/solicitation_model.dart';
import 'package:get/get.dart';

import '../services/solicitation_services.dart';

class DashboardController extends GetxController {
  final SolicitationServices service = Get.find<SolicitationServices>();
  
  RxList<Solicitation> solicitations = <Solicitation>[].obs;
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    
  }
  
  Future<void> getSolicitations() async {
    loading.value = true;
    try {
      solicitations.value = await service.getSolicitations();
    } catch(e) {
      Get.snackbar('Error', e.toString());
    }
    loading.value = false;
  }

}