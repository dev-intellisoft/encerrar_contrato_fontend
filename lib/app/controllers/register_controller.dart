import 'package:encerrar_contrato/app/services/payment_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../models/address_model.dart';
import '../models/asaas_credit_card.dart';
import '../models/asaas_credit_card_holder_info.dart';
import '../models/credit_card_response.dart';
import '../models/customer_model.dart';
import '../models/pix_model.dart';
import '../models/solicitation_model.dart';
import '../services/registration_services.dart';
import '../models/service_model.dart';

class RegisterController extends GetxController {
  RegistrationServices registrationService = Get.find<RegistrationServices>();
  PaymentService paymentService = Get.find<PaymentService>();

  RxList<Service> services = <Service>[].obs;
  Rx<AsaaspaymentResponse> creditCardPaymentResponse =
      AsaaspaymentResponse().obs;
  Rx<PIXResponse> pixResponse = PIXResponse().obs;
  Rx<Solicitation> solicitation = Solicitation(
    customer: Customer(),
    address: Address(),
  ).obs;
  Rx<ASAASCreditCardHolderInfo> creditCardHolderInfo =
      ASAASCreditCardHolderInfo().obs;
  Rx<ASAASCreditCard> creditCard = ASAASCreditCard().obs;
  RxBool isLoading = false.obs;
  RxString cep = ''.obs;

  Rx<PlatformFile?> documentPhoto = Rx<PlatformFile?>(null);
  Rx<PlatformFile?> photoWithDocument = Rx<PlatformFile?>(null);
  Rx<PlatformFile?> lastDocument = Rx<PlatformFile?>(null);
  Rx<PlatformFile?> rentContract = Rx<PlatformFile?>(null);

  bool isValidCEP(String cep) {
    cep = cep.replaceAll(RegExp(r'\D'), '');
    final regex = RegExp(r'^\d{5}-?\d{3}$');
    return regex.hasMatch(cep);
  }

  Future<bool> searchCep(String cep) async {
    Address address = await registrationService.getCep(cep);
    solicitation.update((s) => s!.address = address);
    return false;
  }

  setCep(String text) {
    cep.value = text;
    if (isValidCEP(cep.value)) {
      searchCep(text);
    }
  }

  Future<void> getServices(String type) async {
    services.value = await registrationService.getServices(type: type);
  }

  Future<void> createSolicitation() async {
    try {
      await registrationService.createSolicitation(solicitation.value);
      Get.snackbar('Success', 'Solicitação criada com sucesso');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> register() async {
    Get.back();
    try {
      isLoading.value = true;
      solicitation.value = await registrationService.register(
        solicitation.value,
      );
      print(solicitation.value.toJson());
      Get.snackbar('Success', 'Solicitação criada com sucesso');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setPaymentTypeToCreditCard() async {
    creditCard.value.holderName = solicitation.value.customer!.name ?? '';
    creditCardHolderInfo.value.name = solicitation.value.customer!.name ?? '';
    creditCardHolderInfo.value.cpfCnpj = solicitation.value.customer!.cpf ?? '';
    creditCardHolderInfo.value.phone = solicitation.value.customer!.phone ?? '';
    creditCardHolderInfo.value.email = solicitation.value.customer!.email ?? '';
    creditCardHolderInfo.value.postalCode =
        solicitation.value.address!.zipCode ?? '';
    creditCardHolderInfo.value.addressNumber =
        solicitation.value.address!.number ?? '';
    solicitation.update((s) => s!.paymentType = 'cc');
  }

  Future<void> processCreditCardPayment() async {
    try {
      isLoading.value = true;
      var data = {
        'creditCardHolderInfo': creditCardHolderInfo.toJson(),
        'creditCard': creditCard.toJson(),
      };

      creditCardPaymentResponse.value = await paymentService
          .processCreditCardPayment(
            data: data,
            solicitationId: solicitation.value.id,
          );

      print(creditCardPaymentResponse.toJson());
    } catch (e) {
      print(e);
    } finally {
      Future.delayed(5.seconds, () => isLoading.value = false);
    }
  }

  Future<void> processPIXPayment() async {
    try {
      isLoading.value = true;
      pixResponse.value = await paymentService.processPIXPayment(
        solicitationId: solicitation.value.id,
      );
      print(pixResponse.value.toJson());
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> transfer() async {
    Get.back();
    try {
      isLoading.value = true;
      await registrationService.transfer(
        documentPhoto: documentPhoto.value!,
        photoWithDocument: photoWithDocument.value!,
        lastInvoice: lastDocument.value!,
        contract: rentContract.value!,
        soliciation: solicitation.value,
      );
      Get.snackbar('Success', 'Transferência realizada com sucesso');
    } catch (e) {
      print(e);
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
