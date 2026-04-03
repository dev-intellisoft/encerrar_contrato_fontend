import 'package:dio/dio.dart';
import 'package:encerrar_contrato/app/models/customer_model.dart';
import 'package:encerrar_contrato/app/models/solicitation_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:encerrar_contrato/app/routes/app_pages.dart';

import '../models/address_model.dart';
import '../models/agency_model.dart';
import '../models/service_model.dart';
import '../services/agency_service.dart';

class AgencyController extends GetxController {
  static const int _maxUploadSizeInKb = 1300;
  static const int _maxUploadSizeInBytes = _maxUploadSizeInKb * 1024;

  final AgencyService s = Get.find<AgencyService>();
  Rx<Documents> documents = Documents().obs;
  Rx<Solicitation> solicitation =
      Solicitation(
        address: Address(),
        customer: Customer(),
        items: [],
      ).obs;

  List<Agency> agencies = <Agency>[].obs;
  RxBool isLoading = false.obs;
  Rx<Agency> agency = Agency().obs;

  RxString cep = ''.obs;
  final TextEditingController cepController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController newHolderPhoneController =
      TextEditingController();

  RxList<Service> services = <Service>[].obs;

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

  Future<void> fetchAgencies() async {
    try {
      isLoading.value = true;
      agencies = await s.getAll();
    } catch (_) {
      Get.snackbar(
        'Não foi possível carregar as imobiliárias',
        'Tente novamente em instantes.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> save() async {
    try {
      isLoading.value = true;
      final previousImage = agency.value.image;
      if (agency.value.id == null) {
        agency.value = await s.create(agency.value);
      } else {
        agency.value = await s.update(agency.value.id!, agency.value);
        if ((agency.value.image ?? '').isEmpty && previousImage != null) {
          agency.update((a) => a!.image = previousImage);
        }
      }
      await fetchAgencies();
      agency.value = Agency();
      Get.offAllNamed(Routes.AGENCIES);
      Get.snackbar(
        'Imobiliária salva',
        'Os dados da imobiliária foram atualizados com sucesso.',
      );
    } catch (e) {
      if (e is! DioException) {
        Get.snackbar(
          'Não foi possível salvar a imobiliária',
          'Confira os dados e tente novamente.',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAgency(String id) async {
    try {
      isLoading.value = true;
      agency.value = await s.delete(id);
      await fetchAgencies();
      Get.back();
      Get.snackbar(
        'Imobiliária removida',
        'A imobiliária foi removida com sucesso.',
      );
    } catch (e) {
      if (e is! DioException) {
        Get.snackbar(
          'Não foi possível remover a imobiliária',
          'Tente novamente em instantes.',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAgencyImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result == null) return;

    final file = result.files.first;

    agency.update((a) => a!.fileName = file.name);
    agency.update((a) => a!.fileBytes = file.bytes);
    _showUploadFeedback('Logo da imobiliária', file.name);
  }

  Future<void> getServices(String type) async {
    final fetched = await s.getServices(type: type);
    services.value = _buildCoreServices(type, fetched);
  }

  List<Service> _selectedServices() {
    return services
        .where((service) => service.selected)
        .map(
          (service) => service.copyWith(
            companyName: service.companyName?.trim(),
          ),
        )
        .toList();
  }

  void _applyCoreServicesToSolicitation() {
    final selected = _selectedServices();

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

  Future<void> register() async {
    _applyCoreServicesToSolicitation();
    try {
      isLoading.value = true;
      solicitation.value = await s.register(solicitation.value);
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.snackbar(
        'Solicitação enviada',
        'Recebemos os dados e encaminhamos o caso com sucesso.',
      );
    } catch (e) {
      if (e is! DioException) {
        Get.snackbar(
          'Não foi possível enviar a solicitação',
          'Confira os dados e tente novamente.',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> searchCep(String cep) async {
    final address = await s.getCep(cep);
    solicitation.update((s) => s!.address = address);
    return false;
  }

  bool isValidCEP(String cep) {
    final sanitizedCep = cep.replaceAll(RegExp(r'\D'), '');
    final regex = RegExp(r'^\d{5}-?\d{3}$');
    return regex.hasMatch(sanitizedCep);
  }

  void setCep(String text) {
    cep.value = text;
    if (isValidCEP(cep.value)) {
      searchCep(text);
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

  Future<void> transfer() async {
    _applyCoreServicesToSolicitation();
    try {
      isLoading.value = true;
      solicitation.value = await s.transfer(
        documents: documents.value,
        soliciation: solicitation.value,
      );
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.snackbar(
        'Transferência enviada',
        'Seus dados foram recebidos com sucesso.',
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

  void New() {
    solicitation.value =
        Solicitation(
          customer: Customer(),
          address: Address(),
          items: [],
        );
    documents.value = Documents();
    cep.value = '';
    cepController.clear();
    birthDateController.clear();
    newHolderPhoneController.clear();
    services.value =
        services
            .map(
              (service) => service.copyWith(
                selected: false,
                companyName: '',
              ),
            )
            .toList();
  }

  @override
  void onClose() {
    cepController.dispose();
    birthDateController.dispose();
    newHolderPhoneController.dispose();
    super.onClose();
  }
}
