import 'package:encerrar_contrato/app/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../widgets/agency_logo.dart';

class TransferForm extends GetView<RegisterController> {
  TransferForm({super.key});

  // ===== Visual (dark premium legible) =====
  static const _ink = Color(0xFFFFFFFF);
  static const _bgField = Color(0x1AFFFFFF);
  static const _primario = Color(0xFF5E17EB);
  static const _claro = Color(0xFF36BAFE);
  static const _bgCard = Color(0xFF0B0B12);

  // ===== wizard state =====
  final RxInt _step = 1.obs;

  // Validaciones por paso
  final GlobalKey<FormState> _formStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formStep2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formStep3 = GlobalKey<FormState>();

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
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: _bgField,
      prefixIcon: icon != null ? Icon(icon, color: _claro) : null,
      labelStyle: TextStyle(color: _ink.withOpacity(.92), fontWeight: FontWeight.w700),
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
        borderSide: BorderSide(color: Colors.redAccent.withOpacity(.85), width: 1.3),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  TextStyle get _fieldText => const TextStyle(color: _ink, fontWeight: FontWeight.w600);

  TextStyle _titleStyle() => TextStyle(
        color: _ink.withOpacity(.95),
        fontWeight: FontWeight.w900,
        fontSize: 16,
      );

  // ✅ DatePicker con tema CLARO (texto negro)
  Future<void> _pickBirthDate(BuildContext context, TextEditingController dateCtrl) async {
    DateTime initial = DateTime.now().subtract(const Duration(days: 365 * 25));
    final current = dateCtrl.text.trim();
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
      dateCtrl.text = formatted;
      controller.solicitation.value.customer!.birthDate = formatted;
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
            style: TextStyle(
              color: text,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      );
    }

    Widget line() => Expanded(
          child: Container(
            height: 2,
            color: Colors.white.withOpacity(.12),
          ),
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
    if (s == 2) ok = _formStep2.currentState?.validate() ?? false;
    if (s == 3) ok = _formStep3.currentState?.validate() ?? false;

    if (!ok) {
      Get.snackbar(
        'Atenção',
        'Revise os campos deste passo.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: _bgCard,
        colorText: Colors.white,
      );
      return;
    }

    if (s < 3) _step.value = s + 1;
  }

  void _goBack() {
    if (_step.value > 1) _step.value--;
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
              Row(
                children: [AgencyLogo(imagePath: controller.agencyLogo.value!)],
              ),
              const SizedBox(height: 10),

              // ✅ Header pasos
              _stepsHeader(_step.value),
              const SizedBox(height: 12),

              // ✅ Contenido por pasos
              Expanded(
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _step.value == 1
                        ? _step1CurrentHolder(context, birthCtrl, phoneCtrl, confirmPhoneCtrl, phoneMask)
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
                          side: BorderSide(color: Colors.white.withOpacity(.16)),
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
                        onPressed: _step.value < 3 ? _goNext : () {}, // paso 3 no avanza
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primario,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          _step.value < 3 ? 'Siguiente' : 'Último passo',
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
            style: _fieldText,
            cursorColor: _ink,
            onChanged: (text) => controller.solicitation.value.customer!.name = text,
            decoration: _dec(
              label: 'Nome completo',
              hint: 'Digite seu nome completo',
              icon: Icons.person_outline_rounded,
            ),
            validator: (v) => (v ?? '').trim().isEmpty ? 'Informe o nome completo' : null,
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: _fieldText,
                  cursorColor: _ink,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '###.###.###-##',
                      filter: {"#": RegExp(r'[0-9]')},
                    ),
                  ],
                  onChanged: (text) => controller.solicitation.value.customer!.cpf = text,
                  decoration: _dec(label: 'CPF', icon: Icons.badge_outlined),
                  validator: (v) => (v ?? '').trim().isEmpty ? 'Informe o CPF' : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  style: _fieldText,
                  cursorColor: _ink,
                  controller: birthCtrl,
                  readOnly: true,
                  onTap: () => _pickBirthDate(context, birthCtrl),
                  decoration: _dec(
                    label: 'Data de nascimento',
                    hint: 'Selecione no calendário',
                    icon: Icons.cake_outlined,
                  ),
                  validator: (v) => (v ?? '').trim().isEmpty ? 'Selecione a data' : null,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: _fieldText,
                  cursorColor: _ink,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z0-9@.]+')),
                  ],
                  onChanged: (text) => controller.solicitation.value.customer!.email = text,
                  decoration: _dec(label: 'Email', icon: Icons.email_outlined),
                  validator: (v) {
                    final s = (v ?? '').trim();
                    if (s.isEmpty) return 'Informe o email';
                    if (!s.contains('@') || !s.contains('.')) return 'Email inválido';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  style: _fieldText,
                  cursorColor: _ink,
                  controller: phoneCtrl,
                  inputFormatters: [phoneMask],
                  onChanged: (text) => controller.solicitation.value.customer!.phone = text,
                  decoration: _dec(label: 'Telefone (WhatsApp)', icon: Icons.phone_iphone_outlined),
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
            style: _fieldText,
            cursorColor: _ink,
            controller: confirmPhoneCtrl,
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
              final a = _digitsOnly(phoneCtrl.text);
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
                  onChanged: (text) => controller.solicitation.value.address!.street = text,
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
                  onChanged: (text) => controller.solicitation.value.address!.number = text,
                  decoration: _dec(label: 'Número', icon: Icons.numbers_outlined),
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
            onChanged: (text) => controller.solicitation.value.address!.neighborhood = text,
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
                  onChanged: (text) => controller.solicitation.update((s) => s!.address!.city = text),
                  decoration: _dec(label: 'Cidade', icon: Icons.location_city_outlined),
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
                  onChanged: (text) => controller.solicitation.update((s) => s!.address!.state = text),
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

          TextFormField(
            style: _fieldText,
            cursorColor: _ink,
            readOnly: true,
            controller: TextEditingController(text: controller.documents.value.documentPhotoName ?? ''),
            onTap: controller.pickDocumentPhoto,
            decoration: _dec(label: 'Foto do documento', hint: 'Toque para selecionar', icon: Icons.file_present_outlined),
            validator: (v) {
              if ((controller.documents.value.documentPhotoName ?? '').isEmpty) {
                return 'Selecione a foto do documento';
              }
              return null;
            },
          ),

          const SizedBox(height: 10),
          TextFormField(
            style: _fieldText,
            cursorColor: _ink,
            readOnly: true,
            controller: TextEditingController(text: controller.documents.value.photoWithDocumentName ?? ''),
            onTap: controller.pickPhotoWithDocument,
            decoration: _dec(label: 'Foto com documento', hint: 'Toque para selecionar', icon: Icons.badge_outlined),
            validator: (v) {
              if ((controller.documents.value.photoWithDocumentName ?? '').isEmpty) {
                return 'Selecione a foto com documento';
              }
              return null;
            },
          ),

          const SizedBox(height: 10),
          TextFormField(
            style: _fieldText,
            cursorColor: _ink,
            readOnly: true,
            controller: TextEditingController(text: controller.documents.value.lastInvoiceName ?? ''),
            onTap: controller.pickLastInvoice,
            decoration: _dec(label: 'Última fatura do serviço', hint: 'Toque para selecionar', icon: Icons.receipt_long_outlined),
          ),

          const SizedBox(height: 10),
          TextFormField(
            style: _fieldText,
            cursorColor: _ink,
            readOnly: true,
            controller: TextEditingController(text: controller.documents.value.contractName ?? ''),
            onTap: controller.pickContract,
            decoration: _dec(label: 'Inserir contrato (locação / compra e venda)', hint: 'Toque para selecionar', icon: Icons.description_outlined),
          ),

          const SizedBox(height: 10),
          TextFormField(
            style: _fieldText,
            cursorColor: _ink,
            decoration: _dec(label: 'Telefone (novo titular)', icon: Icons.phone_outlined),
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
            style: TextStyle(color: _ink.withOpacity(.92), fontWeight: FontWeight.w800),
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
                          onChanged: (value) => controller.services[index] = service.copyWith(selected: value!),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          service.name ?? '',
                          style: TextStyle(color: _ink.withOpacity(.92), fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      style: _fieldText,
                      cursorColor: _ink,
                      onChanged: (text) => controller.services[index] = service.copyWith(companyName: text),
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
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _bgCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(.10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: TextStyle(color: _ink.withOpacity(.90), fontWeight: FontWeight.w800)),
                Text("R\$ ${_priceTotal().toString()}",
                    style: const TextStyle(color: _ink, fontWeight: FontWeight.w900)),
              ],
            ),
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () => Get.dialog(
              AlertDialog(
                backgroundColor: _bgCard,
                title: Text(
                  'Termo de Consentimento.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _ink.withOpacity(.95), fontWeight: FontWeight.w900),
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
                              style: TextStyle(color: _ink.withOpacity(.92), fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: agree.value
                            ? () {
                                // ✅ valida todo antes de enviar
                                final ok1 = _formStep1.currentState?.validate() ?? false;
                                final ok2 = _formStep2.currentState?.validate() ?? false;
                                final ok3 = _formStep3.currentState?.validate() ?? true;

                                if (!ok1 || !ok2 || !ok3) {
                                  Get.snackbar(
                                    'Atenção',
                                    'Há campos pendentes. Revise os passos 1 e 2.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: _bgCard,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                controller.transfer();
                              }
                            : null,
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(
                            agree.value ? const Color(0xFF0099FF) : Colors.grey,
                          ),
                          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(color: Colors.white.withOpacity(.14), width: 1),
                            ),
                          ),
                          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                          ),
                        ),
                        child: const Text(
                          'ENVIAR',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                  false.obs,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0099FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('ENVIAR INFORMAÇÕES', style: TextStyle(fontWeight: FontWeight.w900)),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  double _priceTotal() {
    double total = 0.0;
    for (var service in controller.services) {
      if (service.selected) total += service.price!;
    }
    return total;
  }
}
