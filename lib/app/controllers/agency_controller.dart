import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import '../models/agency_model.dart';
import '../services/agency_service.dart';

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

  Future<void> addAgency() async {
    try {
      isLoading.value = true;
      agency.value = await services.create(agency.value);
      await fetchAgencies();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAgency(String id, Agency a) async {
    try {
      isLoading.value = true;
      agency.value = await services.update(id, a);
      await fetchAgencies();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAgency(String id) async {
    try {
      isLoading.value = true;
      agency.value = await services.delete(id);
      await fetchAgencies();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File file = File(result!.files.single.path!);
    agency.update((a) => a!.file = file);

    print(agency.toJson());
  }
}
