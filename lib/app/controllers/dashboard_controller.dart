import 'dart:io';
import 'dart:typed_data';

import 'package:encerrar_contrato/app/models/solicitation_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../services/solicitation_services.dart';

class DashboardController extends GetxController {
  final SolicitationServices service = Get.find<SolicitationServices>();

  Rx<Solicitation?> solicitation = Solicitation().obs;
  RxList<Solicitation> solicitations = <Solicitation>[].obs;
  RxBool loading = false.obs;
  RxList<String> documents = <String>[].obs;
  RxMap<String, Uint8List> documentCache = <String, Uint8List>{}.obs;
  RxSet<String> loadingDocuments = <String>{}.obs;
  RxString loadedDocumentsFor = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getSolicitations();
  }

  String documentNameFromPath(String path) {
    final uri = Uri.tryParse(path);
    final hasSegments = uri?.pathSegments.isNotEmpty ?? false;
    final candidate = hasSegments ? uri!.pathSegments.last : path.split('/').last;
    return candidate.isEmpty ? path : candidate;
  }

  String documentLabel(String path) {
    final name = documentNameFromPath(path).replaceAll('_', ' ');
    return name.isEmpty ? 'Documento' : name;
  }

  bool isPdfDocument(String path) {
    return documentNameFromPath(path).toLowerCase().endsWith('.pdf');
  }

  bool isImageDocument(String path) {
    final lower = documentNameFromPath(path).toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.bmp');
  }

  Future<Uint8List?> loadDocumentBytes(String document) async {
    if (documentCache.containsKey(document)) {
      return documentCache[document];
    }
    if (loadingDocuments.contains(document)) {
      return null;
    }

    try {
      loadingDocuments.add(document);
      final res = await service.getDocument(document);
      documentCache[document] = res;
      return res;
    } catch (e) {
      Get.snackbar('Error', 'Falha ao carregar documento');
      return null;
    } finally {
      loadingDocuments.remove(document);
    }
  }

  Future<void> listDocuments() async {
    try {
      final solicitationId = solicitation.value?.id;
      if (solicitationId == null || solicitationId.isEmpty) {
        documents.clear();
        loadedDocumentsFor.value = '';
        return;
      }
      if (loadedDocumentsFor.value == solicitationId) return;

      documents.value = await service.listDocument(solicitationId);
      loadedDocumentsFor.value = solicitationId;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> downloadDocument(String document) async {
    try {
      final bytes = await loadDocumentBytes(document);
      if (bytes == null) return;

      final outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Salvar documento',
        fileName: documentNameFromPath(document),
      );

      if (outputPath == null || outputPath.isEmpty) return;

      await File(outputPath).writeAsBytes(bytes, flush: true);
      Get.snackbar('Sucesso', 'Documento salvo com sucesso');
    } catch (e) {
      Get.snackbar('Error', 'Falha ao salvar documento');
    }
  }

  Future<void> getSolicitations() async {
    loading.value = true;
    try {
      solicitations.value = await service.getSolicitations();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    loading.value = false;
  }

  Future<void> startSolicitation() async {
    try {
      final solicitationId = solicitation.value?.id;
      if (solicitationId == null || solicitationId.isEmpty) {
        Get.snackbar('Error', 'Selecione uma solicitação válida');
        return;
      }

      solicitation.value = await service.startSolicitation(
        solicitationId,
      );
      loadedDocumentsFor.value = '';
      solicitations.value = solicitations
          .map((s) => s.id == solicitationId ? solicitation.value! : s)
          .toList();
      Get.snackbar('Success', 'Solicitação iniciada com sucesso');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> endSolicitation() async {
    try {
      final solicitationId = solicitation.value?.id;
      if (solicitationId == null || solicitationId.isEmpty) {
        Get.snackbar('Error', 'Selecione uma solicitação válida');
        return;
      }

      solicitation.value = await service.endSolicitation(
        solicitationId,
      );
      loadedDocumentsFor.value = '';
      solicitations.value = solicitations
          .map((s) => s.id == solicitationId ? solicitation.value! : s)
          .toList();
      Get.snackbar('Success', 'Solicitação concluída com sucesso');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
