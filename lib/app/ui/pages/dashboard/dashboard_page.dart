import 'package:encerrar_contrato/app/ui/pages/dashboard/widgets/document.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../models/solicitation_model.dart';
import '../../../widgets/drawer.dart';
import '../../../widgets/logo.dart';
import 'widgets/solicitation_tile.dart';
import 'widgets/address.dart';
import 'widgets/customer.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => controller.getSolicitations(),
    );

    // ===== PALETA (dark premium) =====
    const primario = Color(0xFF5E17EB);
    const claro = Color(0xFF36BAFE);
    const bg = Color(0xFF070710);
    const bg2 = Color(0xFF0B0B12);
    const ink = Color(0xFFFFFFFF);
    final muted = Colors.white.withOpacity(.72);

    final w = MediaQuery.of(context).size.width;
    final isNarrow = w < 980;

    InputDecoration _searchDec() {
      return InputDecoration(
        labelText: 'Buscar',
        hintText: 'Digite para buscar',
        labelStyle: TextStyle(color: muted, fontWeight: FontWeight.w700),
        hintStyle: TextStyle(color: muted.withOpacity(.9)),
        prefixIcon: Icon(Icons.search, color: claro),
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

    Widget leftList() {
      return Container(
        decoration: BoxDecoration(
          color: bg2,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.40),
              blurRadius: 22,
              offset: const Offset(0, 14),
            ),
            BoxShadow(
              color: primario.withOpacity(.10),
              blurRadius: 26,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Casos para atender:',
              style: TextStyle(
                color: ink,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => controller.loading.isTrue
                    ? Center(
                        child: CircularProgressIndicator(color: primario),
                      )
                    : controller.solicitations.isEmpty
                        ? Center(
                            child: Text(
                              'Nenhuma solicitação encontrada',
                              style: TextStyle(
                                color: Colors.white.withOpacity(.70),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : Scrollbar(
                            thumbVisibility: true,
                            child: ListView(
                              children: controller.solicitations
                                  .map(
                                    (s) => SolicitationTile(
                                      solicitation: s,
                                      onTap: (v) =>
                                          controller.solicitation.value = v,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
              ),
            ),
          ],
        ),
      );
    }

    Widget rightDetails() {
      return Container(
        decoration: BoxDecoration(
          color: bg2,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.40),
              blurRadius: 22,
              offset: const Offset(0, 14),
            ),
            BoxShadow(
              color: primario.withOpacity(.10),
              blurRadius: 26,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Caso a ser atendido',
              style: TextStyle(
                color: ink,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // ✅ Scroll dentro del panel de detalles
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Obx(
                    () => controller.solicitation.value!.id != null &&
                            controller.solicitation.value!.id! != ''
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Customer(),
                              const SizedBox(height: 10),

                              Address(),
                              const SizedBox(height: 10),

                              Text(
                                controller.solicitation.value!.service ?? '',
                                style: TextStyle(
                                  color: muted,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 10),

                              if (controller.solicitation.value!.service ==
                                      'transfer' ||
                                  controller.solicitation.value!.service ==
                                      'tranfer')
                                Document(),

                              const SizedBox(height: 8),

                              for (var service
                                  in controller.solicitation.value!.services!)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(
                                    'Serviço: ${service.name!}',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(.80),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 14),

                              // ===== Botones con hover + pressed =====
                              if (controller.solicitation.value!.status ==
                                  SolicitationStatus.pending)
                                _ActionButton(
                                  label: 'Iniciar atendimento',
                                  icon: Icons.play_arrow_rounded,
                                  baseColor: primario,
                                  onPressed: () =>
                                      controller.startSolicitation(),
                                )
                              else if (controller.solicitation.value!.status ==
                                  SolicitationStatus.processing)
                                _ActionButton(
                                  label: 'Concluir atendimento',
                                  icon: Icons.check_circle_outline_rounded,
                                  baseColor: Colors.green,
                                  onPressed: () => controller.endSolicitation(),
                                ),

                              const SizedBox(height: 12),

                              // Status
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.06),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(.10)),
                                ),
                                child: Text(
                                  controller.solicitation.value!.status ==
                                          SolicitationStatus.done
                                      ? 'Concluído'
                                      : controller.solicitation.value!.status ==
                                              SolicitationStatus.processing
                                          ? 'Em andamento'
                                          : 'Não iniciado',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: muted,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: Text(
                                'Selecione uma solicitação para ver os detalhes',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: muted,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
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
              width: 260,
              height: 44,
              child: TextFormField(
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
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isNarrow ? 560 : 1200,
            ),
            child: isNarrow
                // ✅ Mobile/narrow: columna con scroll natural
                ? Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 380, child: leftList()),
                                const SizedBox(height: 14),
                                SizedBox(height: 520, child: rightDetails()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                // ✅ Desktop/wide: row como ya tenías
                : Row(
                    children: [
                      SizedBox(width: 500, child: leftList()),
                      const SizedBox(width: 16),
                      Expanded(child: rightDetails()),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// Botón con hover + pressed (feedback visual)
// =====================================================
class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color baseColor;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.baseColor,
    required this.onPressed,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hover = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final bg = _down
        ? widget.baseColor.withOpacity(.75)
        : _hover
            ? widget.baseColor.withOpacity(.92)
            : widget.baseColor;

    final border = _hover || _down
        ? Colors.white.withOpacity(.22)
        : Colors.white.withOpacity(.12);

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
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          height: 48,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
            boxShadow: [
              if (_hover || _down)
                BoxShadow(
                  color: widget.baseColor.withOpacity(.28),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
