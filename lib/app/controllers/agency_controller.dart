// import 'dart:io';

import 'package:encerrar_contrato/app/models/customer_model.dart';
import 'package:encerrar_contrato/app/models/solicitation_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import '../models/agency_model.dart';
import '../services/agency_service.dart';
import '../models/address_model.dart';
import '../models/service_model.dart';

class AgencyController extends GetxController {
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

  RxList<Service> services = <Service>[].obs;

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
      if (agency.value.id == null) {
        agency.value = await s.create(agency.value);
      } else {
        agency.value = await s.update(agency.value.id!, agency.value);
      }
      await fetchAgencies();
      agency.value = Agency();
      Get.back();
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
  }

  Future<void> getServices(String type) async {
    services.value = await s.getServices(type: type);
  }

  Future<void> register() async {
    print("===================>");
    print(solicitation.value.toJson());
    print("<===================");
    for (var s in services) {
      if (s.selected) {
        solicitation.update((e) => e!.items?.add(s));
      }
    }
    Get.back();
    try {
      isLoading.value = true;
      solicitation.value = await s.register(solicitation.value);
      print(solicitation.value.toJson());
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

    documents.update((a) => a!.documentPhotoName = file.name);
    documents.update(
      (a) => a!.documentPhotoByte = file.bytes,
    ); // Uint8List, works everywhere
  }

  Future<void> pickPhotoWithDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any, //allow also pdf
      allowMultiple: false,
      withData: true, // important for Web → gives bytes
    );

    if (result == null) return;

    final file = result.files.first;

    documents.update((a) => a!.photoWithDocumentName = file.name);
    documents.update(
      (a) => a!.photoWithDocumentByte = file.bytes,
    ); // Uint8List, works everywhere
  }

  Future<void> pickLastInvoice() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any, //allow also pdf
      allowMultiple: false,
      withData: true, // important for Web → gives bytes
    );

    if (result == null) return;

    final file = result.files.first;

    documents.update((a) => a!.lastInvoiceName = file.name);
    documents.update(
      (a) => a!.lastInvoiceByte = file.bytes,
    ); // Uint8List, works everywhere
  }

  Future<void> pickContract() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any, //allow also pdf
      allowMultiple: false,
      withData: true, // important for Web → gives bytes
    );

    if (result == null) return;

    final file = result.files.first;

    documents.update((a) => a!.contractName = file.name);
    documents.update(
      (a) => a!.contractByte = file.bytes,
    ); // Uint8List, works everywhere
  }

  Future<void> transfer() async {
    Get.back();
    try {
      isLoading.value = true;
      solicitation.value = await s.transfer(
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

  New() {
    solicitation.value = Solicitation(
      customer: Customer(),
      address: Address(),
      items: [],
    );
  }
}
