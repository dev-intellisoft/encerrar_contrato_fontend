import 'package:encerrar_contrato/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/agency_controller.dart';
import '../../../widgets/drawer.dart';
import '../../../widgets/logo.dart';
import '../../../widgets/agency_logo.dart';

class AgencyPage extends GetView<AgencyController> {
  const AgencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    // Mantengo tu llamada (lógica igual)
    controller.fetchAgencies();

    // ===== PALETA (dark premium) =====
    const primario = Color(0xFF5E17EB);
    const secundario = Color(0xFF2576FB);
    const claro = Color(0xFF36BAFE);

    const bg = Color(0xFF070710);
    const bg2 = Color(0xFF0B0B12);
    const ink = Color(0xFFFFFFFF);
    final muted = Colors.white.withOpacity(.72);

    InputDecoration _searchDec() {
      return InputDecoration(
        labelText: 'Buscar',
        hintText: 'Digite para buscar',
        labelStyle: TextStyle(color: muted, fontWeight: FontWeight.w700),
        hintStyle: TextStyle(color: muted.withOpacity(.9)),
        prefixIcon: const Icon(Icons.search_rounded, color: claro),
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

      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.AGENCY_FORM),
        backgroundColor: primario,
        foregroundColor: Colors.white,
        elevation: 0,
        child: const Icon(Icons.add),
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
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: primario),
                    );
                  }

                  if (controller.agencies.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhuma imobiliária encontrada.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(.70),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: controller.agencies.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final agency = controller.agencies[index];

                      return _AgencyCard(
                        primario: primario,
                        bg2: bg2,
                        muted: muted,
                        logo: AgencyLogo(imagePath: agency.image ?? ""),
                        title: agency.name ?? "-",
                        subtitle: agency.login ?? "-",
                        onTap: () {
                          controller.agency.value = agency;
                          Get.toNamed(Routes.AGENCY_FORM);
                        },
                        onDelete: () => Get.dialog(
                          AlertDialog(
                            backgroundColor: bg2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            title: const Text(
                              'Atenção',
                              style: TextStyle(
                                color: ink,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            content: Text(
                              'Tem certeza que deseja remover a imobiliária?',
                              style: TextStyle(color: muted, fontWeight: FontWeight.w700),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: Text(
                                  'Não',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(.75),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => controller.deleteAgency(agency.id!),
                                child: const Text(
                                  'Sim',
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// Card con hover/pressed (solo estilo)
// =====================================================
class _AgencyCard extends StatefulWidget {
  final Color primario;
  final Color bg2;
  final Color muted;

  final Widget logo;
  final String title;
  final String subtitle;

  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _AgencyCard({
    required this.primario,
    required this.bg2,
    required this.muted,
    required this.logo,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_AgencyCard> createState() => _AgencyCardState();
}

class _AgencyCardState extends State<_AgencyCard> {
  bool _hover = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final bg = _down
        ? Colors.white.withOpacity(.035)
        : _hover
            ? Colors.white.withOpacity(.045)
            : Colors.white.withOpacity(.03);

    final border = _hover
        ? widget.primario.withOpacity(.40)
        : Colors.white.withOpacity(.10);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _down = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _down = true),
        onTapUp: (_) => setState(() => _down = false),
        onTapCancel: () => setState(() => _down = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
            boxShadow: [
              if (_hover || _down)
                BoxShadow(
                  color: widget.primario.withOpacity(.20),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              BoxShadow(
                color: Colors.black.withOpacity(.35),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              widget.logo,
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: widget.muted,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              InkWell(
                onTap: widget.onDelete,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.redAccent.withOpacity(.35)),
                  ),
                  child: const Icon(Icons.delete_outline_rounded,
                      color: Colors.redAccent, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
