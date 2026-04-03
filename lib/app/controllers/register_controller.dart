import 'package:dio/dio.dart';
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
import '../models/service_model.dart';
import '../models/solicitation_model.dart';
import '../services/registration_services.dart';

class RegisterController extends GetxController {
  static const int _maxUploadSizeInKb = 1300;
  static const int _maxUploadSizeInBytes = _maxUploadSizeInKb * 1024;

  final RegistrationServices registrationService =
      Get.find<RegistrationServices>();
  final PaymentService paymentService = Get.find<PaymentService>();

  RxList<Service> services = <Service>[].obs;
  Rx<AsaaspaymentResponse> creditCardPaymentResponse =
      AsaaspaymentResponse().obs;
  Rx<PIXResponse> pixResponse = PIXResponse().obs;
  Rx<Solicitation> solicitation =
      Solicitation(
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
  final TextEditingController newHolderPhoneController =
      TextEditingController();

  List<Service> _buildCoreServices(String type, List<Service> incoming) {
    Service? matchService(List<String> aliases) {
      for (final service in incoming) {
        final name = (service.name ?? '').trim().toLowerCase();
        if (aliases.any((alias) => name.contains(alias))) {
          return service;
        }
      }
      return null;
    }

    Service buildService({
      required String fallbackName,
      required List<String> aliases,
    }) {
      final matched = matchService(aliases);
      return Service(
        id: matched?.id,
        name: matched?.name?.trim().isNotEmpty == true
            ? matched!.name
            : fallbackName,
        description: matched?.description,
        price: matched?.price ?? 0,
        type: matched?.type ?? type,
        companyName: matched?.companyName ?? '',
        selected: matched?.selected ?? false,
      );
    }

    final defaults = <Service>[
      buildService(
        fallbackName: 'Água',
        aliases: ['agua', 'água', 'saneamento', 'water'],
      ),
      buildService(
        fallbackName: 'Luz',
        aliases: ['luz', 'energia', 'eletrica', 'elétrica', 'power'],
      ),
      buildService(
        fallbackName: 'Gás',
        aliases: ['gas', 'gás'],
      ),
    ];

    final usedIds = defaults.map((service) => service.id).whereType<String>().toSet();
    final extras = incoming.where((service) => !usedIds.contains(service.id)).toList();
    return [...defaults, ...extras];
  }

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
    final sanitizedCep = cep.replaceAll(RegExp(r'\D'), '');
    final regex = RegExp(r'^\d{5}-?\d{3}$');
    return regex.hasMatch(sanitizedCep);
  }

  Future<void> getAgencyLogo(String agencyId) async {
    try {
      loadingAgency.value = true;
      agency.value = await registrationService.getAgencyLogo(agencyId);
    } catch (e) {
      if (e is! DioException) {
        Get.snackbar(
          'Não foi possível carregar a imobiliária',
          'Tente novamente em instantes.',
        );
      }
    } finally {
      loadingAgency.value = false;
    }
  }

  Future<bool> searchCep(String cep) async {
    final address = await registrationService.getCep(cep);
    solicitation.update((s) => s!.address = address);
    return false;
  }

  void setCep(String text) {
    cep.value = text;
    if (isValidCEP(cep.value)) {
      searchCep(text);
    }
  }

  @override
  void onClose() {
    cepController.dispose();
    birthDateController.dispose();
    newHolderPhoneController.dispose();
    super.onClose();
  }

  Future<void> getServices(String type) async {
    final fetched = await registrationService.getServices(type: type);
    services.value = _buildCoreServices(type, fetched);
  }

  Future<void> createSolicitation() async {
    try {
      _applyCoreServicesToSolicitation();
      await registrationService.createSolicitation(solicitation.value);
      Get.snackbar(
        'Solicitação enviada',
        'Recebemos seus dados com sucesso.',
      );
    } catch (e) {
      if (e is! DioException) {
        Get.snackbar(
          'Não foi possível enviar',
          'Revise os dados e tente novamente.',
        );
      }
    }
  }

  Future<void> register() async {
    _applyCoreServicesToSolicitation();

    Get.back();
    try {
      isLoading.value = true;
      solicitation.value = await registrationService.register(
        solicitation.value,
      );
      Get.snackbar(
        'Solicitação criada',
        'Tudo certo. Agora você já pode seguir para o pagamento.',
      );
    } catch (e) {
      if (e is! DioException) {
        Get.snackbar(
          'Não foi possível continuar',
          'Revise as informações e tente novamente.',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setPaymentTypeToCreditCard() async {
    creditCard.value.holderName = solicitation.value.customer!.name ?? '';
    creditCardHolderInfo.value.name = solicitation.value.customer!.name ?? '';
    creditCardHolderInfo.value.cpfCnpj = solicitation.value.customer!.cpf ?? '';
    creditCardHolderInfo.value.phone =
        solicitation.value.customer!.phone ?? '';
    creditCardHolderInfo.value.email =
        solicitation.value.customer!.email ?? '';
    creditCardHolderInfo.value.postalCode =
        solicitation.value.address!.zipCode ?? '';
    creditCardHolderInfo.value.addressNumber =
        solicitation.value.address!.number ?? '';
    solicitation.update((s) => s!.paymentType = 'cc');
  }

  Future<void> processCreditCardPayment() async {
    try {
      isLoading.value = true;
      final data = {
        'creditCardHolderInfo': creditCardHolderInfo.toJson(),
        'creditCard': creditCard.toJson(),
      };

      creditCardPaymentResponse.value = await paymentService
          .processCreditCardPayment(
            data: data,
            solicitationId: solicitation.value.id,
          );
    } catch (e) {
      if (e is! DioException) {
        Get.snackbar(
          'Não foi possível processar o cartão',
          'Confira os dados do cartão e tente novamente.',
        );
      }
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
    } catch (e) {
      if (e is! DioException) {
        Get.snackbar(
          'Não foi possível gerar o PIX',
          'Tente novamente em alguns instantes.',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> transfer() async {
    Get.back();
    try {
      _applyCoreServicesToSolicitation();
      isLoading.value = true;
      solicitation.value = await registrationService.transfer(
        documents: documents.value,
        soliciation: solicitation.value,
      );
      Get.snackbar(
        'Transferência enviada',
        'Seus dados foram recebidos. Agora siga para o pagamento.',
      );
    } catch (e) {
      if (e is! DioException) {
        Get.snackbar(
          'Não foi possível enviar a transferência',
          'Confira os dados e tente novamente.',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickDocumentPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      withData: true,
    );

    if (result == null) return;

    final file = result.files.first;
    if (!_isAllowedFileSize(file, 'Foto do documento')) return;

    documents.update((a) => a!.documentPhotoName = file.name);
    documents.update((a) => a!.documentPhotoByte = file.bytes);
    _showUploadFeedback('Foto do documento', file.name);
  }

  Future<void> pickPhotoWithDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      withData: true,
    );

    if (result == null) return;

    final file = result.files.first;
    if (!_isAllowedFileSize(file, 'Foto com documento')) return;

    documents.update((a) => a!.photoWithDocumentName = file.name);
    documents.update((a) => a!.photoWithDocumentByte = file.bytes);
    _showUploadFeedback('Foto com documento', file.name);
  }

  Future<void> pickLastInvoice() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      withData: true,
    );

    if (result == null) return;

    final file = result.files.first;
    if (!_isAllowedFileSize(file, 'Última fatura')) return;

    documents.update((a) => a!.lastInvoiceName = file.name);
    documents.update((a) => a!.lastInvoiceByte = file.bytes);
    _showUploadFeedback('Última fatura', file.name);
  }

  Future<void> pickContract() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      withData: true,
    );

    if (result == null) return;

    final file = result.files.first;
    if (!_isAllowedFileSize(file, 'Contrato')) return;

    documents.update((a) => a!.contractName = file.name);
    documents.update((a) => a!.contractByte = file.bytes);
    _showUploadFeedback('Contrato', file.name);
  }

  void _applyCoreServicesToSolicitation() {
    final selected = services
        .where((service) => service.selected)
        .map(
          (service) => service.copyWith(
            companyName: service.companyName?.trim(),
          ),
        )
        .toList();

    String carrierFor(List<String> aliases) {
      final service = selected.cast<Service?>().firstWhere(
            (item) {
              final name = (item?.name ?? '').trim().toLowerCase();
              return aliases.any((alias) => name.contains(alias));
            },
            orElse: () => null,
          );
      return (service?.companyName ?? '').trim();
    }

    final waterCarrier = carrierFor(['agua', 'água', 'saneamento', 'water']);
    final powerCarrier = carrierFor([
      'luz',
      'energia',
      'eletrica',
      'elétrica',
      'power',
    ]);
    final gasCarrier = carrierFor(['gas', 'gás']);

    solicitation.update((s) {
      if (s == null) return;
      s.items = selected;
      s.water = waterCarrier.isNotEmpty;
      s.waterCarrier = waterCarrier;
      s.power = powerCarrier.isNotEmpty;
      s.powerCarrier = powerCarrier;
      s.gas = gasCarrier.isNotEmpty;
      s.gasCarrier = gasCarrier;
    });
  }
}
