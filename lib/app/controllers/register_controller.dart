import 'package:encerrar_contrato/app/models/agency_model.dart';
import 'package:encerrar_contrato/app/services/payment_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
  static const int _maxUploadSizeInKb = 1300;
  static const int _maxUploadSizeInBytes = _maxUploadSizeInKb * 1024;

  RegistrationServices registrationService = Get.find<RegistrationServices>();
  PaymentService paymentService = Get.find<PaymentService>();

  RxList<Service> services = <Service>[].obs;
  Rx<AsaaspaymentResponse> creditCardPaymentResponse =
      AsaaspaymentResponse().obs;
  Rx<PIXResponse> pixResponse = PIXResponse().obs;
  Rx<Solicitation> solicitation = Solicitation(
    customer: Customer(),
    address: Address(),
    items: [],
  ).obs;
  Rx<ASAASCreditCardHolderInfo> creditCardHolderInfo =
      ASAASCreditCardHolderInfo().obs;
  Rx<ASAASCreditCard> creditCard = ASAASCreditCard().obs;
  RxBool isLoading = false.obs;
  RxString cep = ''.obs;
  Rx<Documents> documents = Documents().obs;

  Rx<Agency> agency = Agency().obs;
  RxBool loadingAgency = false.obs;
  final TextEditingController cepController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  void _showUploadFeedback(String title, String fileName) {
    Get.snackbar(
      'Arquivo carregado',
      '$title: $fileName',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0B0B12),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void _showUploadTooLarge(String title, String fileName) {
    Get.snackbar(
      'Arquivo muito pesado',
      '$title: $fileName excede 1300 KB. Envie um arquivo menor.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF2A0F14),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  bool _isAllowedFileSize(PlatformFile file, String title) {
    if (file.size > _maxUploadSizeInBytes) {
      _showUploadTooLarge(title, file.name);
      return false;
    }
    return true;
  }

  bool isValidCEP(String cep) {
    cep = cep.replaceAll(RegExp(r'\D'), '');
    final regex = RegExp(r'^\d{5}-?\d{3}$');
    return regex.hasMatch(cep);
  }

  Future<void> getAgencyLogo(String agencyId) async {
    try {
      loadingAgency.value = true;
      agency.value = await registrationService.getAgencyLogo(agencyId);
      // solicitation.update((s) => s!.agencyLogo = logo);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loadingAgency.value = false;
    }
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

  @override
  void onClose() {
    cepController.dispose();
    birthDateController.dispose();
    super.onClose();
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
    for (var s in services) {
      if (s.selected) {
        solicitation.update((e) => e!.items?.add(s));
      }
    }
    Get.back();
    try {
      isLoading.value = true;
      solicitation.value = await registrationService.register(
        solicitation.value,
      );
      print(solicitation.value.toJson());
      Get.snackbar('Success', 'Solicitação criada com sucesso');
    } catch (e) {
      print(e);
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

      print(data);
      print(solicitation.value.id);

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
      solicitation.value = await registrationService.transfer(
        documents: documents.value,
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

  Future<void> pickDocumentPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      withData: true, // important for Web → gives bytes
    );

    if (result == null) return;

    final file = result.files.first;
    if (!_isAllowedFileSize(file, 'Foto do documento')) return;

    documents.update((a) => a!.documentPhotoName = file.name);
    documents.update(
      (a) => a!.documentPhotoByte = file.bytes,
    ); // Uint8List, works everywhere
    _showUploadFeedback('Foto do documento', file.name);
  }

  Future<void> pickPhotoWithDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any, //allow also pdf
      allowMultiple: false,
      withData: true, // important for Web → gives bytes
    );

    if (result == null) return;

    final file = result.files.first;
    if (!_isAllowedFileSize(file, 'Foto com documento')) return;

    documents.update((a) => a!.photoWithDocumentName = file.name);
    documents.update(
      (a) => a!.photoWithDocumentByte = file.bytes,
    ); // Uint8List, works everywhere
    _showUploadFeedback('Foto com documento', file.name);
  }

  Future<void> pickLastInvoice() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any, //allow also pdf
      allowMultiple: false,
      withData: true, // important for Web → gives bytes
    );

    if (result == null) return;

    final file = result.files.first;
    if (!_isAllowedFileSize(file, 'Ultima fatura')) return;

    documents.update((a) => a!.lastInvoiceName = file.name);
    documents.update(
      (a) => a!.lastInvoiceByte = file.bytes,
    ); // Uint8List, works everywhere
    _showUploadFeedback('Ultima fatura', file.name);
  }

  Future<void> pickContract() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any, //allow also pdf
      allowMultiple: false,
      withData: true, // important for Web → gives bytes
    );

    if (result == null) return;

    final file = result.files.first;
    if (!_isAllowedFileSize(file, 'Contrato')) return;

    documents.update((a) => a!.contractName = file.name);
    documents.update(
      (a) => a!.contractByte = file.bytes,
    ); // Uint8List, works everywhere
    _showUploadFeedback('Contrato', file.name);
  }
}
