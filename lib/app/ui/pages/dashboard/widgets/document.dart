import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/dashboard_controller.dart';
import 'package:pdfx/pdfx.dart';

class Document extends GetView<DashboardController> {
  const Document({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => controller.listDocuments(),
    );
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text('Documentos'),
      children: [
        SingleChildScrollView(
          child: Row(
            children: [
              ...controller.documents
                  .map(
                    (e) => Tooltip(
                      message: 'Visualizar documento $e',
                      child: IconButton(
                        icon: Icon(Icons.attach_file_rounded),
                        onPressed: () => Get.dialog(
                          AlertDialog(
                            title: Text('Visualizar documento $e'),
                            content: DocumentPreview(document: e),
                            actions: [
                              // TextButton(
                              //   onPressed: () => Get.back(),
                              //   child: Container(
                              //     child: DocumentPreview(document: e),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ],
    );
  }
}

class DocumentPreview extends GetView<DashboardController> {
  const DocumentPreview({super.key, required this.document});

  final String document;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => controller.loadPdf(document),
    );

    return Obx(() {
      if (controller.isLoading.value) return CircularProgressIndicator();

      if (document.contains(".pdf")) {
        return SizedBox(
          width: 600,
          height: 800,
          child: PdfView(
            controller: PdfController(
              document: PdfDocument.openData(controller.documentByte.value!),
            ),
          ),
        );
      }

      return Container(child: Image.memory(controller.documentByte.value!));
    });
  }
}
