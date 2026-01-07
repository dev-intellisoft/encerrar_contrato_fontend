import 'package:encerrar_contrato/app/models/solicitation_model.dart';
import 'package:get/get.dart';
import '../services/solicitation_services.dart';
import 'dart:typed_data';
import 'package:pdfx/pdfx.dart';

class DashboardController extends GetxController {
  final SolicitationServices service = Get.find<SolicitationServices>();

  Rx<Solicitation?> solicitation = Solicitation().obs;
  RxList<Solicitation> solicitations = <Solicitation>[].obs;
  RxBool loading = false.obs;
  RxList<String> documents = <String>[].obs;
  RxList<Uint8List> documentBytes = <Uint8List>[].obs;
  Rx<PdfController?> pdfController = Rx<PdfController?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> loadPdf() async {
    try {
      final res = await service.getDocument(
        '/documents/f29bb805-666a-430b-8aa6-04352f2b2a05/photo_with_document.pdf',
      );

      pdfController.value = PdfController(document: PdfDocument.openData(res));
    } catch (e) {
      Get.snackbar('Error', 'Failed to load PDF');
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> loadDocument() async {
  //   loading.value = true;
  //   final res = await http.get(
  //     Uri.parse(
  //       'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  //     ),
  //   );
  //   if (res.statusCode == 200) {
  //     documentBytes.add(res.bodyBytes);
  //   }
  //   loading.value = false;
  // }

  Future<void> listDocuments() async {
    print("object");
    try {
      documents.value = await service.listDocument(solicitation.value!.id!);
    } catch (e) {
      Get.snackbar('Error', e.toString());
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
      solicitation.value = await service.startSolicitation(
        solicitation.value!.id!,
      );
      solicitations.value = solicitations
          .map((s) => s.id == solicitation.value!.id ? solicitation.value! : s)
          .toList();
      Get.snackbar('Success', 'Solicitação iniciada com sucesso');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> endSolicitation() async {
    try {
      solicitation.value = await service.endSolicitation(
        solicitation.value!.id!,
      );
      solicitations.value = solicitations
          .map((s) => s.id == solicitation.value!.id ? solicitation.value! : s)
          .toList();
      Get.snackbar('Success', 'Solicitação concluida com sucesso');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
