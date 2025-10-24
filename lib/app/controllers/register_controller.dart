import 'package:get/get.dart';

import '../models/address_model.dart';
import '../models/customer_model.dart';
import '../models/solicitation_model.dart';
import '../services/registration_services.dart';

class RegisterController extends GetxController {
  RegistrationServices services = Get.find<RegistrationServices>();
  Rx<Solicitation> solicitation = Solicitation(customer: Customer(), address: Address()).obs;
  RxBool isLoading = false.obs;
  RxString cep = ''.obs;

  bool isValidCEP(String cep) {
    cep = cep.replaceAll(RegExp(r'\D'), '');
    final regex = RegExp(r'^\d{5}-?\d{3}$');
    return regex.hasMatch(cep);
  }

  Future<bool> searchCep(String cep) async {
    Address address = await services.getCep(cep);
    solicitation.update((s) => s!.address = address);
    return false;
  }

  setCep(String text) {
    cep.value = text;
    if(isValidCEP(cep.value)) {
      searchCep(text);
    }
  }
  Future<void> createSolicitation() async {
    try {
      await services.createSolicitation(solicitation.value);
      // Get.offAllNamed(Routes.HOME);
      Get.snackbar('Success', 'Solicitação criada com sucesso');
    } catch(e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> register() async {
    Get.back();
    try {
      isLoading.value = true;
      solicitation.value = await services.register(solicitation.value);
      print(solicitation.value.toJson());
      Get.snackbar('Success', 'Solicitação criada com sucesso');
    } catch(e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

}
