import 'package:encerrar_contrato/app/services/solicitation_services.dart';
import 'package:get/get.dart';
import 'package:encerrar_contrato/app/models/solicitation_model.dart';
import 'package:encerrar_contrato/app/utils/helpers.dart';

class HomeController extends GetxController {
  final SolicitationServices services = Get.find<SolicitationServices>();
  RxBool loading = false.obs;
  RxList<Solicitation> solicitations = <Solicitation>[].obs;
  RxString search = ''.obs;
  RxString email = ''.obs;
  RxBool loadingEmail = false.obs;
  RxString name = ''.obs;
  RxString agency = 'agencya'.obs;
  RxString avatar = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkAgency();
  }

  Future<void> checkAgency() async {
    String? agency = await getAgency();
    String? avatar = await getAvatar();
    if (avatar != null) {
      this.avatar.value = avatar;
    }
    if (agency != null) {
      this.agency.value = agency;
    }
  }

  Future<void> load() async {
    loading.value = true;
    try {
      solicitations.value = await services.getSolicitations();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    loading.value = false;
  }

  Future<void> sendEmail() async {
    try {
      loading.value = true;
      await services.sendEmail(email.value, name.value);
      Get.snackbar('Success', 'Email enviado com sucesso');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }
}
