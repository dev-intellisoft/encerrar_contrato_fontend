import 'dart:io';
import 'dart:typed_data';

import 'package:encerrar_contrato/app/models/solicitation_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/solicitation_services.dart';

class DashboardController extends GetxController {
  static const String _hiddenDoneSolicitationsKey =
      'hidden_done_solicitations';

  final SolicitationServices service = Get.find<SolicitationServices>();
  final GetStorage _storage = GetStorage();

  Rx<Solicitation?> solicitation = Solicitation().obs;
  RxList<Solicitation> solicitations = <Solicitation>[].obs;
  RxBool loading = false.obs;
  RxList<String> documents = <String>[].obs;
  RxMap<String, Uint8List> documentCache = <String, Uint8List>{}.obs;
  RxSet<String> loadingDocuments = <String>{}.obs;
  RxString loadedDocumentsFor = ''.obs;
  RxSet<String> hiddenDoneSolicitationIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadHiddenDoneSolicitations();
    getSolicitations();
  }

  List<Solicitation> get visibleSolicitations => solicitations
      .where((item) => !hiddenDoneSolicitationIds.contains(item.id))
      .toList();

  void _loadHiddenDoneSolicitations() {
    final raw = _storage.read(_hiddenDoneSolicitationsKey);
    if (raw is List) {
      hiddenDoneSolicitationIds.value = raw.map((e) => e.toString()).toSet();
    }
  }

  Future<void> _persistHiddenDoneSolicitations() async {
    await _storage.write(
      _hiddenDoneSolicitationsKey,
      hiddenDoneSolicitationIds.toList(),
    );
  }

  Solicitation _mergeSolicitation(Solicitation current, Solicitation incoming) {
    return Solicitation(
      id: incoming.id ?? current.id,
      customer:
          (incoming.customer?.name?.trim().isNotEmpty ?? false) ||
                  (incoming.customer?.email?.trim().isNotEmpty ?? false) ||
                  (incoming.customer?.cpf?.trim().isNotEmpty ?? false)
              ? incoming.customer
              : current.customer,
      address:
          (incoming.address?.street?.trim().isNotEmpty ?? false) ||
                  (incoming.address?.city?.trim().isNotEmpty ?? false)
              ? incoming.address
              : current.address,
      title: incoming.title ?? current.title,
      description: incoming.description ?? current.description,
      status: incoming.status ?? current.status,
      createdAt: incoming.createdAt ?? current.createdAt,
      updatedAt: incoming.updatedAt ?? current.updatedAt,
      items:
          incoming.items != null && incoming.items!.isNotEmpty
              ? incoming.items
              : current.items,
      pix: incoming.pix ?? current.pix,
      paymentType:
          incoming.paymentType.trim().isNotEmpty
              ? incoming.paymentType
              : current.paymentType,
      paymentStatus:
          incoming.paymentStatus.trim().isNotEmpty
              ? incoming.paymentStatus
              : current.paymentStatus,
      service:
          incoming.service.trim().isNotEmpty
              ? incoming.service
              : current.service,
      agencyId: incoming.agencyId ?? current.agencyId,
      agencyLogo: incoming.agencyLogo ?? current.agencyLogo,
      creditCardHolderInfo:
          incoming.creditCardHolderInfo ?? current.creditCardHolderInfo,
      creditCard: incoming.creditCard ?? current.creditCard,
      protocol: incoming.protocol ?? current.protocol,
      agency: incoming.agency ?? current.agency,
      water: incoming.water || current.water,
      gas: incoming.gas || current.gas,
      power: incoming.power || current.power,
      waterCarrier: incoming.waterCarrier ?? current.waterCarrier,
      gasCarrier: incoming.gasCarrier ?? current.gasCarrier,
      powerCarrier: incoming.powerCarrier ?? current.powerCarrier,
    );
  }

  String documentNameFromPath(String path) {
    final uri = Uri.tryParse(path);
    final hasSegments = uri?.pathSegments.isNotEmpty ?? false;
    final candidate =
        hasSegments ? uri!.pathSegments.last : path.split('/').last;
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
    } catch (_) {
      Get.snackbar('Erro', 'Falha ao carregar documento.');
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
    } catch (_) {
      Get.snackbar('Erro', 'Não foi possível listar os documentos.');
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
      Get.snackbar('Sucesso', 'Documento salvo com sucesso.');
    } catch (_) {
      Get.snackbar('Erro', 'Falha ao salvar documento.');
    }
  }

  Future<void> getSolicitations() async {
    loading.value = true;
    try {
      solicitations.value = await service.getSolicitations();
      final selectedId = solicitation.value?.id;
      if (selectedId != null &&
          selectedId.isNotEmpty &&
          hiddenDoneSolicitationIds.contains(selectedId)) {
        solicitation.value = Solicitation();
      }
    } catch (_) {
      Get.snackbar('Erro', 'Não foi possível carregar os atendimentos.');
    } finally {
      loading.value = false;
    }
  }

  Future<void> startSolicitation() async {
    try {
      final solicitationId = solicitation.value?.id;
      if (solicitationId == null || solicitationId.isEmpty) {
        Get.snackbar('Atenção', 'Selecione uma solicitação válida.');
        return;
      }

      final current = solicitation.value!;
      final updated = await service.startSolicitation(solicitationId);
      solicitation.value = _mergeSolicitation(current, updated);
      loadedDocumentsFor.value = '';
      solicitations.value =
          solicitations
              .map((s) => s.id == solicitationId ? solicitation.value! : s)
              .toList();
      Get.snackbar(
        'Atendimento iniciado',
        'O caso foi marcado como em andamento.',
      );
    } catch (_) {
      Get.snackbar('Erro', 'Não foi possível iniciar o atendimento.');
    }
  }

  Future<void> endSolicitation() async {
    try {
      final solicitationId = solicitation.value?.id;
      if (solicitationId == null || solicitationId.isEmpty) {
        Get.snackbar('Atenção', 'Selecione uma solicitação válida.');
        return;
      }

      final current = solicitation.value!;
      final updated = await service.endSolicitation(solicitationId);
      solicitation.value = _mergeSolicitation(current, updated);
      loadedDocumentsFor.value = '';
      solicitations.value =
          solicitations
              .map((s) => s.id == solicitationId ? solicitation.value! : s)
              .toList();
      Get.snackbar(
        'Atendimento concluído',
        'O caso foi finalizado com sucesso.',
      );
    } catch (_) {
      Get.snackbar('Erro', 'Não foi possível concluir o atendimento.');
    }
  }

  Future<void> hideFinishedSolicitationFromList() async {
    final selected = solicitation.value;
    final solicitationId = selected?.id;

    if (selected == null || solicitationId == null || solicitationId.isEmpty) {
      Get.snackbar('Atenção', 'Selecione uma solicitação válida.');
      return;
    }

    if (selected.status != SolicitationStatus.done) {
      Get.snackbar(
        'Atenção',
        'Essa opção só fica disponível para atendimentos já concluídos.',
      );
      return;
    }

    hiddenDoneSolicitationIds.add(solicitationId);
    await _persistHiddenDoneSolicitations();
    solicitation.value = Solicitation();

    Get.snackbar(
      'Caso ocultado',
      'Ele saiu da lista deste painel, mas continua salvo no sistema.',
    );
  }
}
