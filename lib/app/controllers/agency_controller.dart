// import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import '../models/agency_model.dart';
import '../services/agency_service.dart';
import 'package:get_storage/get_storage.dart';

class AgencyController extends GetxController {
  final AgencyService services = Get.find<AgencyService>();

  List<Agency> agencies = <Agency>[].obs;
  RxBool isLoading = false.obs;
  Rx<Agency> agency = Agency().obs;

  Future<void> fetchAgencies() async {
    try {
      isLoading.value = true;
      agencies = await services.getAll();
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
        agency.value = await services.create(agency.value);
      } else {
        agency.value = await services.update(agency.value.id!, agency.value);
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
      agency.value = await services.delete(id);
      await fetchAgencies();
      Get.back();
      Get.snackbar("Sucesso", "Agência removida com sucesso.");
    } catch (e) {
      print(e);
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
}
