// import 'dart:io';

import 'package:encerrar_contrato/app/models/customer_model.dart';
import 'package:encerrar_contrato/app/models/solicitation_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:encerrar_contrato/app/routes/app_pages.dart';
import '../models/agency_model.dart';
import '../services/agency_service.dart';
import '../models/address_model.dart';
import '../models/service_model.dart';

class AgencyController extends GetxController {
  static const int _maxUploadSizeInKb = 1300;
  static const int _maxUploadSizeInBytes = _maxUploadSizeInKb * 1024;

  final AgencyService s = Get.find<AgencyService>();
  Rx<Documents> documents = Documents().obs;
  Rx<Solicitation> solicitation = Solicitation(
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

  RxList<Service> services = <Service>[].obs;

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
    } catch (e) {
      print(e);
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
      Get.snackbar("Sucesso", "Agência salva com sucesso.");
    } catch (e) {
      print(e);
      Get.snackbar("Erro", "Erro ao salvar a agência.");
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
      Get.snackbar("Sucesso", "Agência removida com sucesso.");
    } catch (e) {
      print(e);
      Get.snackbar('Error', "Erro ao remove agência");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAgencyImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true, // important for Web → gives bytes
    );

    if (result == null) return;

    final file = result.files.first;

    agency.update((a) => a!.fileName = file.name);
    agency.update(
      (a) => a!.fileBytes = file.bytes,
    ); // Uint8List, works everywhere
    _showUploadFeedback('Logo da imobiliaria', file.name);
  }

  Future<void> getServices(String type) async {
    services.value = await s.getServices(type: type);
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

  Future<void> register() async {
    print("===================>");
    print(solicitation.value.toJson());
    print("<===================");
    solicitation.update((e) => e!.items = _selectedServices());
    try {
      isLoading.value = true;
      solicitation.value = await s.register(solicitation.value);
      print(solicitation.value.toJson());
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.snackbar('Success', 'Solicitação criada com sucesso');
    } catch (e) {
      print(e);
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> searchCep(String cep) async {
    Address address = await s.getCep(cep);
    solicitation.update((s) => s!.address = address);
    return false;
  }

  bool isValidCEP(String cep) {
    cep = cep.replaceAll(RegExp(r'\D'), '');
    final regex = RegExp(r'^\d{5}-?\d{3}$');
    return regex.hasMatch(cep);
  }

  setCep(String text) {
    cep.value = text;
    if (isValidCEP(cep.value)) {
      searchCep(text);
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

  Future<void> transfer() async {
    solicitation.update((s) => s!.items = _selectedServices());
    try {
      isLoading.value = true;
      solicitation.value = await s.transfer(
        documents: documents.value,
        soliciation: solicitation.value,
      );
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.snackbar('Success', 'Transferência realizada com sucesso');
    } catch (e) {
      print(e);
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  New() {
    solicitation.value = Solicitation(
      customer: Customer(),
      address: Address(),
      items: [],
    );
    documents.value = Documents();
    cep.value = '';
    cepController.clear();
    birthDateController.clear();
    services.value = services
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
    super.onClose();
  }
}
