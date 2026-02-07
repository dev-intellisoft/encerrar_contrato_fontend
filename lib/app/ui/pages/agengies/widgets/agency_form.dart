import 'package:encerrar_contrato/app/models/agency_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/agency_controller.dart';
import '../../../../widgets/drawer.dart';
import '../../../../widgets/logo.dart';

class AgencyForm extends StatefulWidget {
  const AgencyForm({super.key});

  @override
  State<AgencyForm> createState() => _AgencyFormState();
}

class _AgencyFormState extends State<AgencyForm> {
  final AgencyController controller = Get.find<AgencyController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ✅ Controllers persistentes (no se recrean)
  late final TextEditingController _nameCtrl;
  late final TextEditingController _loginCtrl;
  late final TextEditingController _passCtrl;
  late final TextEditingController _imageCtrl;

  // Para evitar loops cuando sincronizamos texto
  bool _syncing = false;

  @override
  void initState() {
    super.initState();

    _nameCtrl = TextEditingController(text: controller.agency.value.name ?? "");
    _loginCtrl =
        TextEditingController(text: controller.agency.value.login ?? "");
    _passCtrl =
        TextEditingController(text: controller.agency.value.password ?? "");
    _imageCtrl =
        TextEditingController(text: controller.agency.value.image ?? "");

    // ✅ Listeners: actualizan el model sin forzar rebuild de TextField
    _nameCtrl.addListener(() {
      if (_syncing) return;
      controller.agency.update((a) => a!.name = _nameCtrl.text);
    });

    _loginCtrl.addListener(() {
      if (_syncing) return;
      controller.agency.update((a) => a!.login = _loginCtrl.text);
    });

    _passCtrl.addListener(() {
      if (_syncing) return;
      controller.agency.update((a) => a!.password = _passCtrl.text);
    });

    // ✅ Si el agency cambia (por ejemplo al editar otra inmobiliaria),
    // sincronizamos los controllers sin romper el cursor
    ever(controller.agency, (Agency? a) {
      if (a == null) return;
      _syncFromModel(a);
    });
  }

  void _syncFromModel(Agency a) {
    _syncing = true;

    void setText(TextEditingController c, String v) {
      final newValue = v;
      if (c.text == newValue) return;
      c.value = c.value.copyWith(
        text: newValue,
        selection: TextSelection.collapsed(offset: newValue.length),
        composing: TextRange.empty,
      );
    }

    setText(_nameCtrl, a.name ?? "");
    setText(_loginCtrl, a.login ?? "");
    setText(_passCtrl, a.password ?? "");
    setText(_imageCtrl, a.image ?? "");

    _syncing = false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _loginCtrl.dispose();
    _passCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ===== PALETA (dark premium) =====
    const primario = Color(0xFF5E17EB);
    const claro = Color(0xFF36BAFE);
    const bg = Color(0xFF070710);
    const bg2 = Color(0xFF0B0B12);
    const ink = Color(0xFFFFFFFF);
    final muted = Colors.white.withOpacity(.72);

    final w = MediaQuery.of(context).size.width;
    final maxW = (w * 0.38).clamp(360.0, 620.0);

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
      Widget? suffix,
    }) {
      return InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(.55)),
        prefixIcon: icon == null ? null : Icon(icon, color: claro),
        suffixIcon: suffix,
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
                decoration: InputDecoration(
                  labelText: 'Buscar',
                  hintText: 'Digite para buscar',
                  labelStyle:
                      TextStyle(color: muted, fontWeight: FontWeight.w700),
                  hintStyle: TextStyle(color: muted.withOpacity(.9)),
                  prefixIcon: const Icon(Icons.search, color: claro),
                  filled: true,
                  fillColor: Colors.white.withOpacity(.06),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        BorderSide(color: Colors.white.withOpacity(.12)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: primario.withOpacity(.75), width: 1.4),
                  ),
                ),
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
      body: SafeArea(
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
                    // ✅ Solo el título depende de Obx (no rebuilda tus inputs)
                    Obx(() {
                      final isNew = controller.agency.value.id == null;
                      return sectionHeader(isNew
                          ? "Adicionar imobiliária"
                          : "Atualizar imobiliária");
                    }),

                    // ===== Name =====
                    fieldLabel("Nome"),
                    TextField(
                      controller: _nameCtrl,
                      style: const TextStyle(
                        color: ink,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                      cursorColor: primario,
                      decoration: inputDec(
                        hint: "Nome da imobiliária",
                        icon: Icons.apartment_rounded,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ===== Login =====
                    fieldLabel("Login"),
                    TextField(
                      controller: _loginCtrl,
                      style: const TextStyle(
                        color: ink,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                      cursorColor: primario,
                      decoration: inputDec(
                        hint: "Usuário de acesso",
                        icon: Icons.person_outline,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ===== Password =====
                    fieldLabel("Senha"),
                    TextField(
                      controller: _passCtrl,
                      style: const TextStyle(
                        color: ink,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                      cursorColor: primario,
                      obscureText: true,
                      decoration: inputDec(
                        hint: "Senha de acesso",
                        icon: Icons.lock_outline,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ===== Logo (picker) =====
                    fieldLabel("Logo"),
                    GestureDetector(
                      onTap: () async {
                        await controller.pickAgencyImage();
                        // ✅ sincroniza visualmente (por si el controller cambia el model)
                        _syncFromModel(controller.agency.value);
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _imageCtrl,
                          style: const TextStyle(
                            color: ink,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                          decoration: inputDec(
                            hint: "Toque para selecionar o logo",
                            icon: Icons.image_outlined,
                            suffix: Icon(Icons.upload_rounded,
                                color: Colors.white.withOpacity(.75)),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ===== Botões =====
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
                              onPressed: () {
                                controller.agency.value = Agency();
                                Get.back();
                              },
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
    );
  }
}
