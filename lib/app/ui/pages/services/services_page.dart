import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../controllers/services_controller.dart';
import '../../../widgets/logo.dart';
import '../../../widgets/drawer.dart';
import '../../../routes/app_pages.dart';

class ServicesPage extends GetView<ServicesController> {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getServices();
    });

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

    Widget sectionHeader(String title) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
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
              child: Container(height: 1, color: Colors.white.withOpacity(.12)),
            ),
          ],
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
        onPressed: () => Get.toNamed(Routes.SERVICE_FORM),
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
              child: Column(
                children: [
                  sectionHeader("Serviços"),

                  Expanded(
                    child: Obx(() {
                      if (controller.services.isEmpty) {
                        return Center(
                          child: Text(
                            'Nenhum serviço cadastrado.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(.70),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                        itemCount: controller.services.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final s = controller.services[index];

                          return _ServiceCard(
                            primario: primario,
                            muted: muted,
                            title: s.name ?? "-",
                            subtitle: s.description ?? "-",
                            onTap: () {
                              controller.service.value = s;
                              Get.toNamed(Routes.SERVICE_FORM);
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
                                  'Tem certeza que deseja remover o serviço?',
                                  style: TextStyle(
                                    color: muted,
                                    fontWeight: FontWeight.w700,
                                  ),
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
                                    onPressed: () => controller.removeService(
                                      s.id!,
                                    ),
                                    child: const Text(
                                      'Sim',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
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
                ],
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
class _ServiceCard extends StatefulWidget {
  final Color primario;
  final Color muted;

  final String title;
  final String subtitle;

  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ServiceCard({
    required this.primario,
    required this.muted,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
            boxShadow: [
              if (_hover || _down)
                BoxShadow(
                  color: widget.primario.withOpacity(.18),
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
              // Icono izquierdo (decorativo)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.primario.withOpacity(.10),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: widget.primario.withOpacity(.22)),
                ),
                child: Icon(
                  Icons.miscellaneous_services_rounded,
                  color: Colors.white.withOpacity(.9),
                ),
              ),

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
                    const SizedBox(height: 3),
                    Text(
                      widget.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: widget.muted,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        height: 1.2,
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
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.redAccent.withOpacity(.35)),
                  ),
                  child: const Icon(
                    Icons.remove_circle_outline_rounded,
                    color: Colors.redAccent,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
