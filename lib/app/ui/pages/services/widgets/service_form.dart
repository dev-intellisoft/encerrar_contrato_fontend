import 'package:encerrar_contrato/app/models/service_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:encerrar_contrato/app/controllers/services_controller.dart';
import 'package:encerrar_contrato/app/widgets/logo.dart';
import 'package:encerrar_contrato/app/widgets/drawer.dart';

class ServiceForm extends StatefulWidget {
  const ServiceForm({super.key});

  @override
  State<ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  final ServicesController controller = Get.find<ServicesController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;

  bool _syncing = false;

  @override
  void initState() {
    super.initState();

    _nameCtrl = TextEditingController(text: controller.service.value.name ?? "");
    _descCtrl =
        TextEditingController(text: controller.service.value.description ?? "");
    _priceCtrl = TextEditingController(
        text: controller.service.value.price?.toString() ?? "");

    _nameCtrl.addListener(() {
      if (_syncing) return;
      controller.service.update((s) => s!.name = _nameCtrl.text);
    });

    _descCtrl.addListener(() {
      if (_syncing) return;
      controller.service.update((s) => s!.description = _descCtrl.text);
    });

    _priceCtrl.addListener(() {
      if (_syncing) return;
      controller.service.update(
        (s) => s!.price = int.tryParse(_priceCtrl.text),
      );
    });

    // ✅ Si cambia el servicio (editar otro), sincronizamos controllers
    ever(controller.service, (Service? s) {
      if (s == null) return;
      _syncFromModel(s);
    });
  }

  void _syncFromModel(Service s) {
    _syncing = true;

    void setText(TextEditingController c, String v) {
      if (c.text == v) return;
      c.value = c.value.copyWith(
        text: v,
        selection: TextSelection.collapsed(offset: v.length),
        composing: TextRange.empty,
      );
    }

    setText(_nameCtrl, s.name ?? "");
    setText(_descCtrl, s.description ?? "");
    setText(_priceCtrl, s.price?.toString() ?? "");

    _syncing = false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ===== PALETA (dark premium) =====
    const primario = Color(0xFF5E17EB);
    const claro = Color(0xFF36BAFE);
    const secundario = Color(0xFF2576FB);

    const bg = Color(0xFF070710);
    const bg2 = Color(0xFF0B0B12);
    const ink = Color(0xFFFFFFFF);
    final muted = Colors.white.withOpacity(.72);

    // “tercio del medio” + limites (responsive)
    final w = MediaQuery.of(context).size.width;
    final maxW = (w * 0.38).clamp(360.0, 620.0);

    InputDecoration _searchDec() {
      return InputDecoration(
        labelText: 'Buscar',
        hintText: 'Digite para buscar',
        labelStyle: TextStyle(color: muted, fontWeight: FontWeight.w700),
        hintStyle: TextStyle(color: muted.withOpacity(.9)),
        prefixIcon: const Icon(Icons.search, color: claro),
        filled: true,
        fillColor: Colors.white.withOpacity(.06),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primario.withOpacity(.75), width: 1.4),
        ),
      );
    }

    Widget sectionHeader(String title) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: claro,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withOpacity(.92),
                fontWeight: FontWeight.w900,
                fontSize: 13,
                letterSpacing: .9,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white.withOpacity(.12),
              ),
            ),
          ],
        ),
      );
    }

    Widget fieldLabel(String text) {
      return Padding(
        padding: const EdgeInsets.only(left: 2, bottom: 6),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(.90),
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: .2,
          ),
        ),
      );
    }

    InputDecoration inputDec({
      required String hint,
      IconData? icon,
    }) {
      return InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(.55)),
        prefixIcon: icon == null ? null : Icon(icon, color: claro),
        filled: true,
        fillColor: Colors.white.withOpacity(.06),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primario.withOpacity(.75), width: 1.4),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bg,
      endDrawer: DrawerWidget(),
      appBar: AppBar(
        leading: null,
        backgroundColor: bg2,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Logo(),
            const SizedBox(width: 12),
            SizedBox(
              width: 240,
              height: 44,
              child: TextFormField(
                style: const TextStyle(color: ink, fontWeight: FontWeight.w700),
                decoration: _searchDec(),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: Icon(Icons.person_3_rounded,
                color: Colors.white.withOpacity(.9)),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              bg,
              Color.lerp(bg, secundario, .06)!,
              bg,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bg2,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(.08)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.40),
                        blurRadius: 24,
                        offset: const Offset(0, 14),
                      ),
                      BoxShadow(
                        color: primario.withOpacity(.10),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Obx(() {
                        final isNew = controller.service.value.id == null;
                        return sectionHeader(isNew ? "Criar Serviço" : "Editar Serviço");
                      }),

                      fieldLabel("Nome"),
                      TextFormField(
                        controller: _nameCtrl,
                        style: const TextStyle(
                          color: ink,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                        cursorColor: primario,
                        decoration: inputDec(
                          hint: "Digite o nome do serviço",
                          icon: Icons.miscellaneous_services_rounded,
                        ),
                      ),
                      const SizedBox(height: 12),

                      fieldLabel("Descrição"),
                      TextFormField(
                        controller: _descCtrl,
                        maxLines: 3,
                        style: const TextStyle(
                          color: ink,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                        cursorColor: primario,
                        decoration: inputDec(
                          hint: "Digite a descrição do serviço",
                          icon: Icons.description_outlined,
                        ),
                      ),
                      const SizedBox(height: 12),

                      fieldLabel("Preço"),
                      TextFormField(
                        controller: _priceCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          color: ink,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                        cursorColor: primario,
                        decoration: inputDec(
                          hint: "Digite o preço do serviço",
                          icon: Icons.attach_money_rounded,
                        ),
                      ),
                      const SizedBox(height: 12),

                      fieldLabel("Tipo"),
                      Obx(() {
                        return DropdownButtonFormField(
                          value: controller.service.value.type,
                          dropdownColor: bg2,
                          iconEnabledColor: claro,
                          style: const TextStyle(
                            color: ink,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                          decoration: inputDec(
                            hint: "Selecione o tipo",
                            icon: Icons.category_outlined,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'transfer',
                              child: Text('Transferência'),
                            ),
                            DropdownMenuItem(
                              value: 'close',
                              child: Text('Encerramento'),
                            ),
                          ],
                          onChanged: (value) =>
                              controller.service.update((s) => s!.type = value),
                        );
                      }),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: controller.save,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primario,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Salvar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: .2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.redAccent.withOpacity(.65),
                                    width: 1.2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () {
                                  controller.service.value = Service();
                                  Get.back();
                                },
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: .2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      Text(
                        "Encerrar Contrato • Painel",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(.35),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
