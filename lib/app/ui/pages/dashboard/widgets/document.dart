import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../../../../controllers/dashboard_controller.dart';
import 'package:pdfx/pdfx.dart';
import 'dart:typed_data';

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
                            content: Text(
                              'Aqui você pode visualizar o documento $e',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: Container(
                                  child: DocumentPreview(document: e),
                                ),
                              ),
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
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.loadPdf());
    return Obx(() {
      if (controller.isLoading.value ||
          controller.pdfController.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return PdfView(controller: controller.pdfController.value!);
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   PdfController? pdfController;
  //   WidgetsBinding.instance.addPostFrameCallback(
  //     (_) => controller.loadDocument()
  //   );
  //   pdfController = PdfController(
  //     document: PdfDocument.openData(
  //       Uint8List.fromList('${dotenv.env['API_URL']}$document'),
  //     ),
  //     // document: PdfDocument.openFile('${dotenv.env['API_URL']}$document'),
  //     // document: PdfDocument.openAsset('assets/sample.pdf'),
  //   );
  //   if (document.contains(".pdf")) {
  //     return PdfView(controller: pdfController);
  //   }
  //   return Container(
  //     child: Image.network(
  //       '${dotenv.env['API_URL']}$document',
  //       fit: BoxFit.cover,
  //     ),
  //   );
  // }
}

// class PdfViewerPage extends StatelessWidget {
//   final String filePath;

//   const PdfViewerPage({super.key, required this.filePath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("PDF Viewer")),
//       body: PDFView(
//         filePath: filePath,
//         enableSwipe: true,
//         swipeHorizontal: false,
//         autoSpacing: true,
//         pageFling: true,
//       ),
//     );
//   }
// }
