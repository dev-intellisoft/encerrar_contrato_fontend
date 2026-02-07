import 'package:encerrar_contrato/app/widgets/logo.dart';
import 'package:encerrar_contrato/app/widgets/search_icon.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:encerrar_contrato/app/controllers/home_controller.dart';
import '../../../models/solicitation_model.dart';
import '../../../widgets/done.dart';
import '../../../widgets/drawer.dart';
import '../../../widgets/pending.dart';
import '../../../widgets/processing.dart';
import '../dashboard/widgets/solicitation_tile.dart';
import '../../../widgets/agency_logo.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.load());
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    // ===== PALETA (dark premium) =====
    const primario = Color(0xFF5E17EB);
    const secundario = Color(0xFF2576FB);
    const claro = Color(0xFF36BAFE);

    const bg = Color(0xFF070710);
    const bg2 = Color(0xFF0B0B12);

    const ink = Color(0xFFFFFFFF);
    final muted = Colors.white.withOpacity(.72);

    // “tercio del medio” + limites (responsive)
    final w = MediaQuery.of(context).size.width;
    final maxW = (w * 0.34).clamp(360.0, 560.0);

    InputDecoration _inputDec({
      required String label,
      required IconData icon,
      String? hint,
      Widget? prefixIcon,
    }) {
      return InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: muted, fontWeight: FontWeight.w700),
        hintStyle: TextStyle(color: muted.withOpacity(.9)),
        prefixIcon: prefixIcon ?? Icon(icon, color: claro),
        filled: true,
        fillColor: Colors.white.withOpacity(.06),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
      appBar: AppBar(
        title: Logo(),
        backgroundColor: bg2,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(.9)),
        actions: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: Icon(Icons.person_3_rounded, color: Colors.white.withOpacity(.9)),
          ),
        ],
      ),
      endDrawer: DrawerWidget(),
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
        child: Stack(
          children: [
            // glows decorativos
            Positioned(
              top: -120,
              left: -120,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primario.withOpacity(.16),
                ),
              ),
            ),
            Positioned(
              bottom: -140,
              right: -140,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: claro.withOpacity(.12),
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxW),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ===== Top bloco (avatar + texto + botão) =====
                        Container(
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
                            children: [
                              Obx(
                                () => Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AgencyLogo(imagePath: controller.avatar.value),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                'Forneça as informações necessária para o encerramento do contrato.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.78),
                                  fontWeight: FontWeight.w700,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 12),

                              SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () => Get.dialog(
                                    AlertDialog(
                                      backgroundColor: bg2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      title: const Text(
                                        'Detalhes do contrato',
                                        style: TextStyle(
                                          color: ink,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      content: SizedBox(
                                        height: 280,
                                        width: 420,
                                        child: Obx(() {
                                          if (controller.loading.value) {
                                            return Center(
                                              child: CircularProgressIndicator(color: primario),
                                            );
                                          }
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                'Enviar link por e-mail',
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(.70),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 10),

                                              TextField(
                                                onChanged: (value) => controller.name.value = value,
                                                style: const TextStyle(
                                                  color: ink,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                cursorColor: primario,
                                                decoration: _inputDec(
                                                  label: 'Nome',
                                                  hint: 'Digite o nome',
                                                  icon: Icons.person,
                                                ),
                                              ),
                                              const SizedBox(height: 10),

                                              TextFormField(
                                                onChanged: (value) => controller.email.value = value,
                                                style: const TextStyle(
                                                  color: ink,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                cursorColor: primario,
                                                decoration: _inputDec(
                                                  label: 'E-mail',
                                                  hint: 'Digite o e-mail',
                                                  icon: Icons.email,
                                                ),
                                              ),

                                              const SizedBox(height: 14),

                                              SizedBox(
                                                height: 46,
                                                child: ElevatedButton(
                                                  onPressed: controller.sendEmail,
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: primario,
                                                    foregroundColor: Colors.white,
                                                    elevation: 0,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(14),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Enviar',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w900,
                                                      letterSpacing: .2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primario,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                                  ),
                                  child: const Text(
                                    'Cadastrar informações',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: .2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ===== Histórico + busca =====
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: bg2,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.white.withOpacity(.08)),
                            boxShadow: [
                              BoxShadow(
                                color: primario.withOpacity(.10),
                                blurRadius: 24,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Histórico de contratos',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ink,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                onChanged: (value) => controller.search.value = value,
                                style: const TextStyle(
                                  color: ink,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                                cursorColor: primario,
                                decoration: _inputDec(
                                  label: 'Procurar',
                                  hint: 'Nome do cliente',
                                  icon: Icons.search,
                                  prefixIcon: SearchIcon(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ===== Lista =====
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: bg2,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.white.withOpacity(.08)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.45),
                                blurRadius: 18,
                                offset: const Offset(0, 12),
                              ),
                              BoxShadow(
                                color: primario.withOpacity(.10),
                                blurRadius: 26,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.55,
                            child: Obx(
                              () => controller.loading.value
                                  ? Center(
                                      child: CircularProgressIndicator(color: primario),
                                    )
                                  : ListView(
                                      children: controller.solicitations.isEmpty
                                          ? [
                                              Center(
                                                child: Text(
                                                  'Nenhum solicitação!',
                                                  style: TextStyle(
                                                    color: Colors.white.withOpacity(.70),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              )
                                            ]
                                          : controller.solicitations
                                              .where(
                                                (s) => s.customer!.name!
                                                    .toLowerCase()
                                                    .contains(
                                                      controller.search.value.toLowerCase(),
                                                    ),
                                              )
                                              .map(
                                                (s) => SolicitationTile(
                                                  solicitation: s,
                                                  onTap: (solicitation) {
                                                    Get.dialog(
                                                      AlertDialog(
                                                        backgroundColor: bg2,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(18),
                                                        ),
                                                        title: const Text(
                                                          'Detalhes do contrato',
                                                          style: TextStyle(
                                                            color: ink,
                                                            fontWeight: FontWeight.w900,
                                                          ),
                                                        ),
                                                        content: SizedBox(
                                                          height: 320,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                '${solicitation.customer!.name}',
                                                                style: const TextStyle(
                                                                  color: ink,
                                                                  fontWeight: FontWeight.w900,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 6),
                                                              Text(
                                                                '${solicitation.customer!.email}',
                                                                style: TextStyle(color: muted),
                                                              ),
                                                              Text(
                                                                '${solicitation.customer!.phone}',
                                                                style: TextStyle(color: muted),
                                                              ),
                                                              Text(
                                                                '${solicitation.customer!.cpf}',
                                                                style: TextStyle(color: muted),
                                                              ),
                                                              const SizedBox(height: 10),
                                                              Text(
                                                                '${solicitation.address!.street}, ${solicitation.address!.number} ${solicitation.address!.complement}',
                                                                style: TextStyle(color: muted),
                                                              ),
                                                              Text(
                                                                '${solicitation.address!.neighborhood}, ${solicitation.address!.city}, ${solicitation.address!.state}',
                                                                style: TextStyle(color: muted),
                                                              ),
                                                              const SizedBox(height: 12),
                                                              if (solicitation.status == SolicitationStatus.done)
                                                                Row(
                                                                  children: [
                                                                    Text('Encerrado', style: TextStyle(color: muted)),
                                                                    const SizedBox(width: 6),
                                                                    Done(),
                                                                  ],
                                                                )
                                                              else if (solicitation.status == SolicitationStatus.processing)
                                                                Row(
                                                                  children: [
                                                                    Text('Em andamento', style: TextStyle(color: muted)),
                                                                    const SizedBox(width: 6),
                                                                    Processing(),
                                                                  ],
                                                                )
                                                              else
                                                                Row(
                                                                  children: [
                                                                    Text('Pendente', style: TextStyle(color: muted)),
                                                                    const SizedBox(width: 6),
                                                                    Pending(),
                                                                  ],
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                              .toList(),
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "Encerrar Contrato • Mobile",
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
          ],
        ),
      ),
    );
  }
}
