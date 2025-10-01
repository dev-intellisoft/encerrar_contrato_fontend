

import 'package:encerrar_contrato/app/models/solicitation_model.dart';
import 'package:get/get.dart';

import '../models/address_model.dart';
import '../models/customer_model.dart';
import '../routes/app_pages.dart';
import '../services/solicitation_services.dart';

class SolicitationController extends GetxController {
  Rx<Solicitation> solicitation = Solicitation(customer: Customer(), address: Address()).obs;
  SolicitationServices services = Get.find<SolicitationServices>();

  RxBool agreement = false.obs;

  RxString cep = ''.obs;

  setCep(String text) {
    cep.value = text;
    if(isValidCEP(cep.value)) {
      searchCep(text);
    }
  }

  Future<bool> searchCep(String cep) async {
    Address address = await services.getCep(cep);
    solicitation.update((s) => s!.address = address);
    return false;
  }

  bool isValidCEP(String cep) {
    cep = cep.replaceAll(RegExp(r'\D'), '');
    final regex = RegExp(r'^\d{5}-?\d{3}$');
    return regex.hasMatch(cep);
  }

  Future<void> createSolicitation() async {
    try {
      await services.createSolicitation(solicitation.value);
      Get.offAllNamed(Routes.HOME);
      Get.snackbar('Success', 'Solicitação criada com sucesso');
    } catch(e) {
      Get.snackbar('Error', e.toString());
    }
  }
}