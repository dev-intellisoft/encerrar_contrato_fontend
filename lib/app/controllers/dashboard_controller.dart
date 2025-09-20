
import 'package:encerrar_contrato/app/models/solicitation_model.dart';
import 'package:get/get.dart';

import '../services/solicitation_services.dart';

class DashboardController extends GetxController {
  final SolicitationServices service = Get.find<SolicitationServices>();

  Rx<Solicitation?> solicitation = Solicitation().obs;
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

  Future<void> startSolicitation() async {
    try {
      solicitation.value = await service.startSolicitation(solicitation.value!.id!);
      solicitations.value = solicitations.map((s) => s!.id == solicitation.value!.id ? solicitation.value! : s).toList();
      Get.snackbar('Success', 'Solicitação iniciada com sucesso');
    } catch(e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> endSolicitation() async {
    try {
      solicitation.value = await service.endSolicitation(solicitation.value!.id!);
      solicitations.value = solicitations.map((s) => s!.id == solicitation.value!.id ? solicitation.value! : s).toList();
      Get.snackbar('Success', 'Solicitação concluida com sucesso');
    } catch(e) {
      Get.snackbar('Error', e.toString());
    }
  }

}