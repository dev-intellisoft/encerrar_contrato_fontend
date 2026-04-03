import 'package:encerrar_contrato/app/controllers/agency_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TransferForm extends GetView<AgencyController> {
  TransferForm({super.key});

  // ===== Visual (dark premium legible) =====
  static const _ink = Color(0xFFFFFFFF);
  static const _bgField = Color(0x1AFFFFFF);
  static const _primario = Color(0xFF5E17EB);
  static const _claro = Color(0xFF36BAFE);
  static const _bgCard = Color(0xFF0B0B12);

  // ===== wizard state =====
  final RxInt _step = 1.obs;
  final ScrollController _stepScrollController = ScrollController();

  // Validaciones por paso
  final GlobalKey<FormState> _formStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formStep2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formStep3 = GlobalKey<FormState>();
  final MaskTextInputFormatter _newHolderPhoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Helpers
  String _digitsOnly(String s) => s.replaceAll(RegExp(r'\D'), '');

  String _formatBR(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  InputDecoration _dec({
    required String label,
    String? hint,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: _bgField,
      prefixIcon: icon != null ? Icon(icon, color: _claro) : null,
      suffixIcon: suffixIcon,
      labelStyle: TextStyle(
        color: _ink.withOpacity(.92),
        fontWeight: FontWeight.w700,
      ),
      hintStyle: TextStyle(color: _ink.withOpacity(.75)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: _ink.withOpacity(.18), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: _primario.withOpacity(.90), width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.redAccent.withOpacity(.85),
          width: 1.3,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  TextStyle get _fieldText =>
      const TextStyle(color: _ink, fontWeight: FontWeight.w600);

  TextStyle _titleStyle() => TextStyle(
    color: _ink.withOpacity(.95),
    fontWeight: FontWeight.w900,
    fontSize: 16,
  );

  bool _isImageFile(String? name) {
    if (name == null) return false;
    final lower = name.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.bmp');
  }

  String _formatFileSize(Uint8List? bytes) {
    if (bytes == null) return '';
    final length = bytes.length;
    if (length >= 1024 * 1024) {
      return '${(length / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    if (length >= 1024) {
      return '${(length / 1024).toStringAsFixed(0)} KB';
    }
    return '$length B';
  }

  bool _hasRequiredTransferDocuments() {
    final docs = controller.documents.value;
    return (docs.documentPhotoName ?? '').isNotEmpty &&
        docs.documentPhotoByte != null &&
        (docs.photoWithDocumentName ?? '').isNotEmpty &&
        docs.photoWithDocumentByte != null;
  }

  int _selectedDocumentsCount() {
    final docs = controller.documents.value;
    var total = 0;
    if ((docs.documentPhotoName ?? '').isNotEmpty &&
        docs.documentPhotoByte != null) {
      total++;
    }
    if ((docs.photoWithDocumentName ?? '').isNotEmpty &&
        docs.photoWithDocumentByte != null) {
      total++;
    }
    if ((docs.lastInvoiceName ?? '').isNotEmpty && docs.lastInvoiceByte != null) {
      total++;
    }
    if ((docs.contractName ?? '').isNotEmpty && docs.contractByte != null) {
      total++;
    }
    return total;
  }

  Widget _uploadFeedbackBanner() {
    final selectedCount = _selectedDocumentsCount();
    final requiredDone = _hasRequiredTransferDocuments();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: requiredDone
              ? [
                  const Color(0xFF0E7490).withOpacity(.34),
                  const Color(0xFF2DD4BF).withOpacity(.18),
                ]
              : [
                  _primario.withOpacity(.20),
                  _claro.withOpacity(.10),
                ],
        ),
        border: Border.all(
          color: requiredDone
              ? const Color(0xFF2DD4BF).withOpacity(.45)
              : Colors.white.withOpacity(.12),
        ),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: requiredDone
                  ? const Color(0xFF2DD4BF).withOpacity(.22)
                  : Colors.white.withOpacity(.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              requiredDone
                  ? Icons.check_circle_rounded
                  : Icons.cloud_upload_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  requiredDone
                      ? 'Arquivos obrigatorios carregados'
                      : 'Uploads selecionados: $selectedCount/4',
                  style: TextStyle(
                    color: _ink.withOpacity(.96),
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  requiredDone
                      ? 'Voce ja pode seguir para o proximo passo.'
                      : 'Assim que escolher um arquivo, o card muda e mostra o nome ou preview.',
                  style: TextStyle(
                    color: _ink.withOpacity(.72),
                    fontSize: 11.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _selectedUploadEntries() {
    final docs = controller.documents.value;
    final entries = <Map<String, dynamic>>[];

    void addEntry({
      required String label,
      required String? fileName,
      required Uint8List? fileBytes,
      required IconData icon,
      required bool requiredField,
    }) {
      if (fileName == null || fileName.isEmpty || fileBytes == null) return;
      entries.add({
        'label': label,
        'fileName': fileName,
        'fileBytes': fileBytes,
        'icon': icon,
        'requiredField': requiredField,
      });
    }

    addEntry(
      label: 'Documento',
      fileName: docs.documentPhotoName,
      fileBytes: docs.documentPhotoByte,
      icon: Icons.file_present_outlined,
      requiredField: true,
    );
    addEntry(
      label: 'Selfie com documento',
      fileName: docs.photoWithDocumentName,
      fileBytes: docs.photoWithDocumentByte,
      icon: Icons.badge_outlined,
      requiredField: true,
    );
    addEntry(
      label: 'Ultima fatura',
      fileName: docs.lastInvoiceName,
      fileBytes: docs.lastInvoiceByte,
      icon: Icons.receipt_long_outlined,
      requiredField: false,
    );
    addEntry(
      label: 'Contrato',
      fileName: docs.contractName,
      fileBytes: docs.contractByte,
      icon: Icons.description_outlined,
      requiredField: false,
    );

    return entries;
  }

  Widget _selectedUploadsOverview() {
    final entries = _selectedUploadEntries();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: Container(
        key: ValueKey(
          'selected-uploads-${entries.map((item) => item['fileName']).join('|')}',
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: entries.isEmpty
                        ? Colors.white.withOpacity(.08)
                        : const Color(0xFF2DD4BF).withOpacity(.16),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(.10)),
                  ),
                  child: Icon(
                    entries.isEmpty
                        ? Icons.visibility_outlined
                        : Icons.verified_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entries.isEmpty
                            ? 'Os arquivos carregados vao aparecer aqui'
                            : 'Confira os arquivos antes de continuar',
                        style: TextStyle(
                          color: _ink.withOpacity(.96),
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entries.isEmpty
                            ? 'Assim que voce selecionar uma imagem, o preview fica visivel neste bloco.'
                            : 'Se a imagem apareceu aqui, o upload foi reconhecido com sucesso.',
                        style: TextStyle(
                          color: _ink.withOpacity(.70),
                          fontSize: 11.5,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (entries.isNotEmpty) ...[
              const SizedBox(height: 14),
              SizedBox(
                height: 124,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, index) {
                    final item = entries[index];
                    final fileName = item['fileName'] as String;
                    final fileBytes = item['fileBytes'] as Uint8List;
                    final imageFile = _isImageFile(fileName);

                    return Container(
                      width: 154,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.black.withOpacity(.18),
                        border: Border.all(
                          color: (item['requiredField'] as bool)
                              ? const Color(0xFF2DD4BF).withOpacity(.34)
                              : Colors.white.withOpacity(.10),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['label'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _ink.withOpacity(.94),
                              fontWeight: FontWeight.w800,
                              fontSize: 11.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                width: double.infinity,
                                color: Colors.white.withOpacity(.05),
                                child: imageFile
                                    ? Image.memory(fileBytes, fit: BoxFit.cover)
                                    : Icon(
                                        item['icon'] as IconData,
                                        color: _claro.withOpacity(.92),
                                        size: 34,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            fileName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _ink.withOpacity(.72),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _scrollStepToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_stepScrollController.hasClients) return;
      _stepScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    });
  }

  List<dynamic> _selectedServicesSummary() {
    return controller.services.where((service) => service.selected).toList();
  }

  Widget _serviceSpotlight() {
    final selectedServices = _selectedServicesSummary();

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(.05),
        border: Border.all(color: Colors.white.withOpacity(.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _claro.withOpacity(.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.apartment_outlined,
                  color: _claro.withOpacity(.96),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Servicos informados neste envio',
                      style: TextStyle(
                        color: _ink.withOpacity(.96),
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedServices.isEmpty
                          ? 'Selecione o tipo de servico e informe a empresa responsavel antes de enviar.'
                          : 'Esse resumo ajuda a conferir rapido o tipo de servico e a empresa de cada caso.',
                      style: TextStyle(
                        color: _ink.withOpacity(.68),
                        fontSize: 11.5,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (selectedServices.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...selectedServices.map((service) {
              final serviceName = (service.name ?? '').toString().trim();
              final companyName = (service.companyName ?? '').toString().trim();
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black.withOpacity(.18),
                  border: Border.all(color: Colors.white.withOpacity(.08)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      color: _claro.withOpacity(.92),
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceName.isEmpty ? 'Servico sem nome' : serviceName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _ink.withOpacity(.95),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            companyName.isEmpty
                                ? 'Empresa responsavel nao informada'
                                : companyName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _ink.withOpacity(.66),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _uploadStatusChip({
    required bool selected,
    required bool requiredField,
  }) {
    final color = selected
        ? const Color(0xFF2DD4BF)
        : requiredField
            ? const Color(0xFFF59E0B)
            : Colors.white.withOpacity(.55);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.45)),
      ),
      child: Text(
        selected ? 'Arquivo carregado' : requiredField ? 'Obrigatório' : 'Opcional',
        style: TextStyle(
          color: selected ? Colors.white : _ink.withOpacity(.88),
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _uploadCard({
    required String title,
    required String subtitle,
    required String? fileName,
    required Uint8List? fileBytes,
    required bool requiredField,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    final hasFile = fileName != null && fileName.isNotEmpty && fileBytes != null;
    final imageFile = hasFile && _isImageFile(fileName);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: hasFile
                ? [
                    _primario.withOpacity(.24),
                    _claro.withOpacity(.14),
                  ]
                : [
                    Colors.white.withOpacity(.06),
                    Colors.white.withOpacity(.03),
                  ],
          ),
          border: Border.all(
            color: hasFile
                ? _claro.withOpacity(.40)
                : Colors.white.withOpacity(.12),
          ),
          boxShadow: [
            BoxShadow(
              color: hasFile
                  ? _primario.withOpacity(.18)
                  : Colors.black.withOpacity(.18),
              blurRadius: hasFile ? 22 : 14,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(.12)),
                  ),
                  child: Icon(icon, color: _claro, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _ink.withOpacity(.96),
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _ink.withOpacity(.68),
                          fontSize: 11.5,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _uploadStatusChip(
              selected: hasFile,
              requiredField: requiredField,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeIn,
                child: hasFile
                    ? TweenAnimationBuilder<double>(
                        key: ValueKey(fileName),
                        tween: Tween(begin: .92, end: 1),
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          return Transform.scale(scale: value, child: child);
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black.withOpacity(.16),
                            border: Border.all(
                              color: Colors.white.withOpacity(.12),
                            ),
                          ),
                          child: imageFile
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.memory(fileBytes, fit: BoxFit.cover),
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black.withOpacity(.05),
                                              Colors.black.withOpacity(.55),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 12,
                                        right: 12,
                                        bottom: 12,
                                        child: Text(
                                          fileName,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 11.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.description_rounded,
                                        color: _claro.withOpacity(.95),
                                        size: 34,
                                      ),
                                      const Spacer(),
                                      Text(
                                        fileName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: _ink.withOpacity(.95),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _formatFileSize(fileBytes),
                                        style: TextStyle(
                                          color: _ink.withOpacity(.65),
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      )
                    : Container(
                        key: ValueKey(title),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(.04),
                          border: Border.all(
                            color: Colors.white.withOpacity(.10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              color: _ink.withOpacity(.68),
                              size: 34,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Toque para selecionar',
                              style: TextStyle(
                                color: _ink.withOpacity(.86),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Imagem ou documento',
                              style: TextStyle(
                                color: _ink.withOpacity(.58),
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ DatePicker con tema CLARO (texto negro)
  Future<void> _pickBirthDate(
    BuildContext context,
    AgencyController controller,
  ) async {
    DateTime initial = DateTime.now().subtract(const Duration(days: 365 * 25));
    final current = controller.solicitation.value.customer?.birthDate ?? '';
    final parts = current.split('/');
    if (parts.length == 3) {
      final dd = int.tryParse(parts[0]);
      final mm = int.tryParse(parts[1]);
      final yy = int.tryParse(parts[2]);
      if (dd != null && mm != null && yy != null) {
        final tryDate = DateTime(yy, mm, dd);
        if (tryDate.year == yy && tryDate.month == mm && tryDate.day == dd) {
          initial = tryDate;
        }
      }
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (ctx, child) {
        final base = ThemeData.light();
        return Theme(
          data: base.copyWith(
            colorScheme: base.colorScheme.copyWith(
              primary: _primario,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black, // ✅ texto negro
            ),
            dialogBackgroundColor: Colors.white,
            textTheme: base.textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted = _formatBR(picked);
      controller.birthDateController.text = formatted;
      controller.solicitation.update((s) => s!.customer!.birthDate = formatted);
    }
  }

  Widget _stepsHeader(int active) {
    Widget dot(int n) {
      final isActive = n == active;
      final isDone = n < active;

      Color bg;
      Color border;
      Color text;

      if (isActive) {
        bg = _primario;
        border = _primario.withOpacity(.9);
        text = Colors.white;
      } else if (isDone) {
        bg = Colors.white.withOpacity(.16);
        border = Colors.white.withOpacity(.28);
        text = Colors.white;
      } else {
        bg = Colors.white.withOpacity(.08);
        border = Colors.white.withOpacity(.18);
        text = Colors.white.withOpacity(.85);
      }

      return Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Center(
          child: Text(
            '$n',
            style: TextStyle(color: text, fontWeight: FontWeight.w900),
          ),
        ),
      );
    }

    Widget line() => Expanded(
      child: Container(height: 2, color: Colors.white.withOpacity(.12)),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.10)),
      ),
      child: Row(
        children: [
          dot(1),
          const SizedBox(width: 10),
          line(),
          const SizedBox(width: 10),
          dot(2),
          const SizedBox(width: 10),
          line(),
          const SizedBox(width: 10),
          dot(3),
        ],
      ),
    );
  }

  void _goNext() {
    final s = _step.value;
    bool ok = false;

    if (s == 1) ok = _formStep1.currentState?.validate() ?? false;
    if (s == 2) {
      ok = _formStep2.currentState?.validate() ?? false;
      if (ok && !_hasRequiredTransferDocuments()) {
        ok = false;
      }
    }
    if (s == 3) ok = _formStep3.currentState?.validate() ?? false;

    if (!ok) {
      Get.snackbar(
        'Atenção',
        s == 2 && !_hasRequiredTransferDocuments()
            ? 'Selecione a foto do documento e a foto com documento.'
            : 'Revise os campos deste passo.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: _bgCard,
        colorText: Colors.white,
      );
      return;
    }

    if (s < 3) {
      _step.value = s + 1;
      _scrollStepToTop();
    }
  }

  void _goBack() {
    if (_step.value > 1) {
      _step.value--;
      _scrollStepToTop();
    }
  }

  void _openConsentDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: _bgCard,
        title: Text(
          'Termo de Consentimento.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _ink.withOpacity(.95),
            fontWeight: FontWeight.w900,
          ),
        ),
        content: ObxValue(
          (agree) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Autorizo o envio dos meus dados pessoais, conforme informado neste formulário, para que a empresa ENCERRAR CONTRATO possa utilizá-los exclusivamente no processo.',
                textAlign: TextAlign.justify,
                style: TextStyle(color: _ink.withOpacity(.88)),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: _ink.withOpacity(.70),
                    ),
                    child: Checkbox(
                      value: agree.value,
                      activeColor: _primario,
                      checkColor: Colors.white,
                      onChanged: (value) => agree.value = !agree.value,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Li e aceito.',
                      style: TextStyle(
                        color: _ink.withOpacity(.92),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: agree.value ? controller.transfer : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                    agree.value ? const Color(0xFF0099FF) : Colors.grey,
                  ),
                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: Colors.white.withOpacity(.14),
                        width: 1,
                      ),
                    ),
                  ),
                  padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                  ),
                ),
                child: const Text(
                  'ENVIAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          false.obs,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getServices('transfer');
    });

    // Controllers locales (mantienen valor visual)
    final birthCtrl = TextEditingController(
      text: controller.solicitation.value.customer?.birthDate ?? '',
    );

    final phoneCtrl = TextEditingController(
      text: controller.solicitation.value.customer?.phone ?? '',
    );

    final confirmPhoneCtrl = TextEditingController(
      text: controller.solicitation.value.customer?.phone ?? '',
    );

    final phoneMask = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
    );

    return Obx(
      () => SizedBox(
        height: 400,
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // ✅ Header pasos
              _stepsHeader(_step.value),
              const SizedBox(height: 12),

              // ✅ Contenido por pasos
              Expanded(
                child: SingleChildScrollView(
                  controller: _stepScrollController,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _step.value == 1
                        ? _step1CurrentHolder(
                            context,
                            birthCtrl,
                            phoneCtrl,
                            confirmPhoneCtrl,
                            phoneMask,
                          )
                        : _step.value == 2
                        ? _step2NewHolderDocuments(context)
                        : _step3ServicesAndTotal(context),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ✅ barra inferior de navegación
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: _bgCard,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(.10)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _step.value == 1 ? null : _goBack,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withOpacity(.16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Voltar',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _step.value < 3
                            ? _goNext
                            : () => _openConsentDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primario,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          _step.value < 3
                              ? 'Siguiente'
                              : 'Enviar informacoes',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================= PASO 1 =========================
  Widget _step1CurrentHolder(
    BuildContext context,
    TextEditingController birthCtrl,
    TextEditingController phoneCtrl,
    TextEditingController confirmPhoneCtrl,
    MaskTextInputFormatter phoneMask,
  ) {
    return Form(
      key: _formStep1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        key: const ValueKey('step1'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Passo 1 • Dados do atual titular', style: _titleStyle()),
          const SizedBox(height: 12),

          TextFormField(
            initialValue: controller.solicitation.value.customer!.name ?? '',
            style: _fieldText,
            cursorColor: _ink,
            onChanged: (text) =>
                controller.solicitation.value.customer!.name = text,
            decoration: _dec(
              label: 'Nome completo',
              hint: 'Digite seu nome completo',
              icon: Icons.person_outline_rounded,
            ),
            validator: (v) =>
                (v ?? '').trim().isEmpty ? 'Informe o nome completo' : null,
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue:
                      controller.solicitation.value.customer!.cpf ?? '',
                  style: _fieldText,
                  cursorColor: _ink,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '###.###.###-##',
                      filter: {"#": RegExp(r'[0-9]')},
                    ),
                  ],
                  onChanged: (text) =>
                      controller.solicitation.value.customer!.cpf = text,
                  decoration: _dec(label: 'CPF', icon: Icons.badge_outlined),
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? 'Informe o CPF' : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: controller.birthDateController,
                  style: _fieldText,
                  cursorColor: _ink,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '##/##/####',
                      filter: {"#": RegExp(r'[0-9]')},
                    ),
                  ],
                  decoration: _dec(
                    label: 'Data de nascimento',
                    hint: 'Selecione no calendário',
                    icon: Icons.cake_outlined,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month_outlined),
                      onPressed: () => _pickBirthDate(context, controller),
                    ),
                  ),
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? 'Selecione a data' : null,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue:
                      controller.solicitation.value.customer!.email ?? '',
                  style: _fieldText,
                  cursorColor: _ink,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp(r'[^a-zA-Z0-9@.]+'),
                    ),
                  ],
                  onChanged: (text) =>
                      controller.solicitation.value.customer!.email = text,
                  decoration: _dec(label: 'Email', icon: Icons.email_outlined),
                  validator: (v) {
                    final s = (v ?? '').trim();
                    if (s.isEmpty) return 'Informe o email';
                    if (!s.contains('@') || !s.contains('.')) {
                      return 'Email inválido';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue:
                      controller.solicitation.value.customer!.phone ?? '',
                  style: _fieldText,
                  cursorColor: _ink,
                  // controller: phoneCtrl,
                  inputFormatters: [phoneMask],
                  onChanged: (text) =>
                      controller.solicitation.value.customer!.phone = text,
                  decoration: _dec(
                    label: 'Telefone (WhatsApp)',
                    icon: Icons.phone_iphone_outlined,
                  ),
                  validator: (v) {
                    final d = _digitsOnly(v ?? '');
                    if (d.isEmpty) return 'Informe o telefone';
                    if (d.length < 10) return 'Telefone inválido';
                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          TextFormField(
            initialValue:
                controller.solicitation.value.customer!.confirmPhone ?? '',
            style: _fieldText,
            cursorColor: _ink,
            // controller: confirmPhoneCtrl,
            onChanged: (text) =>
                controller.solicitation.value.customer!.confirmPhone = text,
            inputFormatters: [
              MaskTextInputFormatter(
                mask: '(##) #####-####',
                filter: {"#": RegExp(r'[0-9]')},
              ),
            ],
            decoration: _dec(
              label: 'Confirmar Telefone',
              hint: 'Digite o mesmo número novamente',
              icon: Icons.verified_outlined,
            ),
            validator: (v) {
              final a = _digitsOnly(
                controller.solicitation.value.customer?.phone ?? '',
              );
              final b = _digitsOnly(v ?? '');
              if (b.isEmpty) return 'Confirme o telefone';
              if (a != b) return 'Os telefones não coincidem';
              return null;
            },
          ),

          const SizedBox(height: 16),
          Text('Endereço', style: _titleStyle()),
          const SizedBox(height: 10),

          TextFormField(
            style: _fieldText,
            cursorColor: _ink,
            controller: controller.cepController,
            inputFormatters: [
              MaskTextInputFormatter(
                mask: '##.###-###',
                filter: {"#": RegExp(r'[0-9]')},
              ),
            ],
            onChanged: controller.setCep,
            decoration: _dec(label: 'CEP', icon: Icons.location_on_outlined),
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: _fieldText,
                  cursorColor: _ink,
                  controller: TextEditingController(
                    text: controller.solicitation.value.address?.street,
                  ),
                  onChanged: (text) =>
                      controller.solicitation.value.address!.street = text,
                  decoration: _dec(label: 'Rua', icon: Icons.signpost_outlined),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 140,
                child: TextFormField(
                  style: _fieldText,
                  cursorColor: _ink,
                  initialValue: controller.solicitation.value.address?.number,
                  onChanged: (text) =>
                      controller.solicitation.value.address!.number = text,
                  decoration: _dec(
                    label: 'Número',
                    icon: Icons.numbers_outlined,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          TextFormField(
            style: _fieldText,
            cursorColor: _ink,
            controller: TextEditingController(
              text: controller.solicitation.value.address?.neighborhood,
            ),
            onChanged: (text) =>
                controller.solicitation.value.address!.neighborhood = text,
            decoration: _dec(label: 'Bairro', icon: Icons.map_outlined),
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: _fieldText,
                  cursorColor: _ink,
                  controller: TextEditingController(
                    text: controller.solicitation.value.address?.city,
                  ),
                  onChanged: (text) => controller.solicitation.update(
                    (s) => s!.address!.city = text,
                  ),
                  decoration: _dec(
                    label: 'Cidade',
                    icon: Icons.location_city_outlined,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 140,
                child: TextFormField(
                  style: _fieldText,
                  cursorColor: _ink,
                  controller: TextEditingController(
                    text: controller.solicitation.value.address?.state,
                  ),
                  onChanged: (text) => controller.solicitation.update(
                    (s) => s!.address!.state = text,
                  ),
                  decoration: _dec(label: 'UF', icon: Icons.flag_outlined),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========================= PASO 2 =========================
  Widget _step2NewHolderDocuments(BuildContext context) {
    return Form(
      key: _formStep2,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        key: const ValueKey('step2'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Passo 2 • Dados do novo titular', style: _titleStyle()),
          const SizedBox(height: 12),

          Text(
            'Os uploads agora ficam em cards mais visíveis, com preview automático para imagens e estado claro para cada arquivo.',
            style: TextStyle(
              color: _ink.withOpacity(.72),
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.amber.withOpacity(.24)),
            ),
            child: Text(
              'Limite por arquivo: 1300 KB. Arquivos maiores serão recusados para evitar falha no envio.',
              style: TextStyle(
                color: Colors.white.withOpacity(.84),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            style: _fieldText,
            cursorColor: _ink,
            controller: controller.newHolderPhoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [_newHolderPhoneMask],
            decoration: _dec(
              label: 'Telefone (novo titular)',
              hint: 'Numero principal para contato do novo titular',
              icon: Icons.phone_outlined,
            ),
            validator: (v) {
              final digits = _digitsOnly(v ?? '');
              if (digits.isEmpty) return 'Informe o telefone do novo titular';
              if (digits.length < 10) return 'Telefone invalido';
              return null;
            },
          ),
          const SizedBox(height: 10),
          Text(
            'Deixamos esse telefone no topo porque ele costuma ser a referencia mais consultada na conferencia.',
            style: TextStyle(
              color: _ink.withOpacity(.62),
              fontSize: 11.5,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          _selectedUploadsOverview(),
          const SizedBox(height: 14),
          _uploadFeedbackBanner(),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 560;
              final itemWidth = isWide
                  ? (constraints.maxWidth - 12) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: itemWidth,
                    height: 268,
                    child: _uploadCard(
                      title: 'Foto do documento',
                      subtitle: 'Documento frontal ou página principal',
                      fileName: controller.documents.value.documentPhotoName,
                      fileBytes: controller.documents.value.documentPhotoByte,
                      requiredField: true,
                      onTap: controller.pickDocumentPhoto,
                      icon: Icons.file_present_outlined,
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: 268,
                    child: _uploadCard(
                      title: 'Foto com documento',
                      subtitle: 'Selfie segurando o documento visível',
                      fileName: controller.documents.value.photoWithDocumentName,
                      fileBytes:
                          controller.documents.value.photoWithDocumentByte,
                      requiredField: true,
                      onTap: controller.pickPhotoWithDocument,
                      icon: Icons.badge_outlined,
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: 268,
                    child: _uploadCard(
                      title: 'Última fatura',
                      subtitle: 'Comprovante recente do serviço',
                      fileName: controller.documents.value.lastInvoiceName,
                      fileBytes: controller.documents.value.lastInvoiceByte,
                      requiredField: false,
                      onTap: controller.pickLastInvoice,
                      icon: Icons.receipt_long_outlined,
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    height: 268,
                    child: _uploadCard(
                      title: 'Contrato',
                      subtitle: 'Locação, compra e venda ou equivalente',
                      fileName: controller.documents.value.contractName,
                      fileBytes: controller.documents.value.contractByte,
                      requiredField: false,
                      onTap: controller.pickContract,
                      icon: Icons.description_outlined,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ========================= PASO 3 =========================
  Widget _step3ServicesAndTotal(BuildContext context) {
    return Form(
      key: _formStep3,
      child: Column(
        key: const ValueKey('step3'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Passo 3 • Serviços e envio', style: _titleStyle()),
          const SizedBox(height: 12),

          Text(
            'Serviço a encerrar:',
            style: TextStyle(
              color: _ink.withOpacity(.92),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.services.length,
            itemBuilder: (context, index) {
              final service = controller.services[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: _ink.withOpacity(.70),
                        ),
                        child: Checkbox(
                          value: controller.services[index].selected,
                          activeColor: _primario,
                          checkColor: Colors.white,
                          onChanged: (value) => controller.services[index] =
                              service.copyWith(selected: value!),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          service.name ?? '',
                          style: TextStyle(
                            color: _ink.withOpacity(.92),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      style: _fieldText,
                      cursorColor: _ink,
                      onChanged: (text) => controller.services[index] = service
                          .copyWith(companyName: text),
                      decoration: _dec(
                        label: 'Empresa prestadora do serviço',
                        hint: 'Ex: Copel, Sanepar, Vivo...',
                        icon: Icons.apartment_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            },
          ),

          const SizedBox(height: 6),
          _serviceSpotlight(),

          // ✅✅✅ TOTAL (APENAS ESTÉTICA - mais chamativo)
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_primario.withOpacity(.22), _claro.withOpacity(.12)],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(.14),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _primario.withOpacity(.22),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(.12),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.cloud_done_outlined,
                    color: _claro.withOpacity(.95),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Envio direto',
                        style: TextStyle(
                          color: _ink.withOpacity(.78),
                          fontWeight: FontWeight.w800,
                          letterSpacing: .6,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Solicitação enviada ao master',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _ink.withOpacity(.98),
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          letterSpacing: .2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(.10),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'SEM PAG.',
                    style: TextStyle(
                      color: _ink.withOpacity(.78),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  double _priceTotal() {
    double total = 0.0;
    for (var service in controller.services) {
      if (service.selected) total += (service.price ?? 0);
    }
    return total;
  }
}
