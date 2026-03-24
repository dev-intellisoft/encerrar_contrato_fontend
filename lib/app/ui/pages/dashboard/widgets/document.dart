import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';

import '../../../../controllers/dashboard_controller.dart';

class Document extends GetView<DashboardController> {
  const Document({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.listDocuments());

    return Obx(() {
      final documents = controller.documents;

      if (documents.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(.10)),
          ),
          child: Text(
            'Nenhum documento recebido.',
            style: TextStyle(
              color: Colors.white.withOpacity(.70),
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 760
              ? 4
              : constraints.maxWidth > 520
                  ? 3
                  : 2;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: documents.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: .95,
            ),
            itemBuilder: (context, index) {
              final document = documents[index];
              return _DocumentCard(document: document);
            },
          );
        },
      );
    });
  }
}

class _DocumentCard extends GetView<DashboardController> {
  const _DocumentCard({required this.document});

  final String document;

  @override
  Widget build(BuildContext context) {
    final isPdf = controller.isPdfDocument(document);
    final isImage = controller.isImageDocument(document);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _openPreview(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withOpacity(.05),
          border: Border.all(color: Colors.white.withOpacity(.10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  color: Colors.white.withOpacity(.04),
                  child: Obx(() {
                    final bytes = controller.documentCache[document];
                    final loading = controller.loadingDocuments.contains(document);

                    if (bytes != null && isImage) {
                      return Image.memory(bytes, fit: BoxFit.cover);
                    }

                    if (loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isPdf
                              ? Icons.picture_as_pdf_rounded
                              : isImage
                                  ? Icons.image_outlined
                                  : Icons.insert_drive_file_outlined,
                          color: Colors.white.withOpacity(.84),
                          size: 34,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isPdf
                              ? 'PDF'
                              : isImage
                                  ? 'Imagem'
                                  : 'Arquivo',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.75),
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              controller.documentLabel(document),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openPreview(context),
                    icon: Icon(
                      isPdf ? Icons.visibility_rounded : Icons.open_in_full_rounded,
                      size: 16,
                    ),
                    label: Text(isPdf ? 'Abrir' : 'Ver'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withOpacity(.12)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Baixar arquivo',
                  onPressed: () => controller.downloadDocument(document),
                  icon: const Icon(Icons.download_rounded),
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPreview(BuildContext context) async {
    await controller.loadDocumentBytes(document);
    if (!context.mounted) return;

    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0B0B12),
        insetPadding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900, maxHeight: 700),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.documentLabel(document),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => controller.downloadDocument(document),
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Baixar'),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Expanded(child: DocumentPreview(document: document)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DocumentPreview extends GetView<DashboardController> {
  const DocumentPreview({super.key, required this.document});

  final String document;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bytes = controller.documentCache[document];
      final loading = controller.loadingDocuments.contains(document);

      if (loading && bytes == null) {
        return const Center(child: CircularProgressIndicator());
      }

      if (bytes == null) {
        return Center(
          child: Text(
            'Nao foi possivel carregar este documento.',
            style: TextStyle(
              color: Colors.white.withOpacity(.75),
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }

      if (controller.isPdfDocument(document)) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: PdfView(
            controller: PdfController(
              document: PdfDocument.openData(bytes),
            ),
          ),
        );
      }

      if (controller.isImageDocument(document)) {
        return InteractiveViewer(
          minScale: 0.8,
          maxScale: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.memory(bytes, fit: BoxFit.contain),
          ),
        );
      }

      return Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.04),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(.10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.insert_drive_file_outlined,
                color: Colors.white,
                size: 42,
              ),
              const SizedBox(height: 12),
              Text(
                'Use o botao baixar para salvar este arquivo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(.78),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
