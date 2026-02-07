// ========================== CLOSE_FORM.dart ==========================
// ✅ Cambios incluidos:
// 1) Data de nascimento con CALENDARIO (solo fechas reales) + letras negras en el calendario
// 2) Confirmar Telefone (valida que coincida) + bloquea envío si no coincide
// ====================================================================

import 'package:encerrar_contrato/app/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../widgets/agency_logo.dart';

class CloseForm extends GetView<RegisterController> {
  CloseForm({super.key});

  // ✅ helpers de estilo (legible en dark)
  static const _ink = Color(0xFFFFFFFF);
  static const _bgField = Color(0x1AFFFFFF); // blanco 10%
  static const _primario = Color(0xFF5E17EB);
  static const _claro = Color(0xFF36BAFE);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _digitsOnly(String s) => s.replaceAll(RegExp(r'\D'), '');

  String _formatBR(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  // ✅ DatePicker con tema CLARO (texto negro)
  Future<void> _pickBirthDate(
    BuildContext context,
    TextEditingController dateCtrl,
  ) async {
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
              primary: _primario, // header/selección
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

  TextStyle get _fieldText => const TextStyle(
        color: _ink,
        fontWeight: FontWeight.w600,
      );

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => controller.getServices("close"),
    );

    // ✅ controllers locales (datepicker + phone confirm)
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
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              children: [
                Row(
                  children: [AgencyLogo(imagePath: controller.agencyLogo.value)],
                ),
                const SizedBox(height: 20),

                Text(
                  'Preencha os campos solicitados:',
                  style: TextStyle(
                    color: _ink.withOpacity(.92),
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 10),

                TextFormField(
                  style: _fieldText,
                  cursorColor: _ink,
                  onChanged: (text) =>
                      controller.solicitation.value.customer!.name = text,
                  decoration: _dec(
                    label: 'Nome completo',
                    hint: 'Digite seu nome completo',
                    icon: Icons.person_outline_rounded,
                  ),
                  validator: (v) {
                    if ((v ?? '').trim().isEmpty) return 'Informe seu nome completo';
                    return null;
                  },
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
                        onChanged: (text) =>
                            controller.solicitation.value.customer!.cpf = text,
                        decoration: _dec(
                          label: 'CPF',
                          icon: Icons.badge_outlined,
                        ),
                        validator: (v) {
                          if ((v ?? '').trim().isEmpty) return 'Informe o CPF';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),

                    // ✅ DATA con calendario
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
                        validator: (v) {
                          if ((v ?? '').trim().isEmpty) return 'Selecione a data';
                          final parts = v!.split('/');
                          if (parts.length != 3) return 'Data inválida';
                          final dd = int.tryParse(parts[0]);
                          final mm = int.tryParse(parts[1]);
                          final yy = int.tryParse(parts[2]);
                          if (dd == null || mm == null || yy == null) return 'Data inválida';
                          final d = DateTime(yy, mm, dd);
                          if (d.year != yy || d.month != mm || d.day != dd) return 'Data inválida';
                          return null;
                        },
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
                          FilteringTextInputFormatter.deny(
                            RegExp(r'[^a-zA-Z0-9@.]+'),
                          ),
                        ],
                        onChanged: (text) =>
                            controller.solicitation.value.customer!.email = text,
                        decoration: _dec(
                          label: 'Email',
                          icon: Icons.email_outlined,
                        ),
                        validator: (v) {
                          final s = (v ?? '').trim();
                          if (s.isEmpty) return 'Informe o email';
                          if (!s.contains('@') || !s.contains('.')) return 'Email inválido';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),

                    // ✅ TELEFONE (principal)
                    Expanded(
                      child: TextFormField(
                        style: _fieldText,
                        cursorColor: _ink,
                        controller: phoneCtrl,
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

                // ✅ TELEFONE (confirmación)
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

                const SizedBox(height: 20),

                Text(
                  'Endereço:',
                  style: TextStyle(
                    color: _ink.withOpacity(.92),
                    fontWeight: FontWeight.w800,
                  ),
                ),
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
                  decoration: _dec(
                    label: 'CEP',
                    icon: Icons.location_on_outlined,
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: _fieldText,
                        cursorColor: _ink,
                        controller: TextEditingController(
                          text: controller.solicitation.value.address?.street,
                        ),
                        decoration: _dec(
                          label: 'Rua',
                          icon: Icons.signpost_outlined,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 110,
                      child: TextFormField(
                        style: _fieldText,
                        cursorColor: _ink,
                        onChanged: (text) => controller.solicitation.update(
                          (s) => s!.address!.number = text,
                        ),
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
                  decoration: _dec(
                    label: 'Bairro',
                    icon: Icons.map_outlined,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: _fieldText,
                        cursorColor: _ink,
                        controller: TextEditingController(
                          text: controller.solicitation.value.address!.city,
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
                      width: 110,
                      child: TextFormField(
                        style: _fieldText,
                        cursorColor: _ink,
                        controller: TextEditingController(
                          text: controller.solicitation.value.address?.state,
                        ),
                        onChanged: (text) => controller.solicitation.update(
                          (s) => s!.address!.state = text,
                        ),
                        decoration: _dec(
                          label: 'UF',
                          icon: Icons.flag_outlined,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  'Serviço a encerrar:',
                  style: TextStyle(
                    color: _ink.withOpacity(.92),
                    fontWeight: FontWeight.w800,
                  ),
                ),

                Container(
                  margin: const EdgeInsets.all(10),
                  child: ListView.builder(
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
                              onChanged: (text) => controller.services[index] =
                                  service.copyWith(companyName: text),
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
                ),

                Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(color: _ink.withOpacity(.90), fontWeight: FontWeight.w800),
                      ),
                      Text(
                        "R\$ ${_priceTotal().toString()}",
                        style: const TextStyle(color: _ink, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: () => Get.dialog(
                    AlertDialog(
                      backgroundColor: const Color(0xFF0B0B12),
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
                            const SizedBox(height: 6),
                            Text('Clique para assinar.', style: TextStyle(color: _ink.withOpacity(.85))),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: agree.value
                                  ? () {
                                      final ok = _formKey.currentState?.validate() ?? false;
                                      if (!ok) {
                                        Get.snackbar(
                                          'Atenção',
                                          'Verifique os campos (data e telefone).',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: const Color(0xFF0B0B12),
                                          colorText: Colors.white,
                                        );
                                        return;
                                      }
                                      controller.register();
                                    }
                                  : null,
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll<Color>(
                                  agree.value ? const Color(0xFF0099FF) : Colors.grey,
                                ),
                                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: Colors.white.withOpacity(.14), width: 1),
                                  ),
                                ),
                                padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                ),
                              ),
                              child: const Text('ENVIAR',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                            ),
                          ],
                        ),
                        false.obs,
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll<Color>(Color(0xFF0099FF)),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.white.withOpacity(.14), width: 1),
                      ),
                    ),
                    padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                  ),
                  child: const Text(
                    'ENVIAR INFORMAÇÕES',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
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
