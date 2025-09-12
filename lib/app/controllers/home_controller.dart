import 'dart:convert';
import 'package:encerrar_contrato/app/services/solicitation_services.dart';
import 'package:get/get.dart';
import 'package:encerrar_contrato/app/models/solicitation_model.dart';
import 'package:encerrar_contrato/app/utils/helpers.dart';

import '../routes/app_pages.dart';


class HomeController extends GetxController {
  final SolicitationServices services = Get.find<SolicitationServices>();
  RxBool loading = false.obs;
  RxList<Solicitation> solicitations = <Solicitation>[].obs;
  RxString search = ''.obs;

  RxString agency = 'agencya'.obs;

  @override
  void onInit() {
    super.onInit();
    checkAgency();
  }

  Future<void> checkAgency() async {
    String? agency = await getAgency();
    if(agency != null) {
      this.agency.value = agency;
    }
  }

  Future<void> load() async {
    loading.value = true;
    try {
      solicitations.value = await services.getSolicitations();
    } catch(e) {
      Get.snackbar('Error', e.toString());
    }
    loading.value = false;
  }


}

