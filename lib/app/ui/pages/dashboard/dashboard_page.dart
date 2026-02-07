import 'package:encerrar_contrato/app/ui/pages/dashboard/widgets/document.dart'
    as doc_widget;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../models/solicitation_model.dart';
import '../../../widgets/drawer.dart';
import '../../../widgets/logo.dart';
import 'widgets/solicitation_tile.dart';

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

    // =========================
    // UI helpers (labels afuera)
    // =========================
    Widget sectionHeader(String title) {
      return Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 10),
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

    InputDecoration cleanInputDec({
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

    // Campo editable simple usando el controller actual (GetX)
    Widget editableField({
      required String label,
      required String value,
      required ValueChanged<String> onChanged,
      required String hint,
      IconData? icon,
      TextInputType? keyboardType,
    }) {
      final ctrl = TextEditingController(text: value);
      ctrl.selection = TextSelection.fromPosition(
        TextPosition(offset: ctrl.text.length),
      );

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            fieldLabel(label),
            TextFormField(
              controller: ctrl,
              onChanged: onChanged,
              keyboardType: keyboardType,
              style: const TextStyle(
                color: ink,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              cursorColor: primario,
              decoration: cleanInputDec(hint: hint, icon: icon),
            ),
          ],
        ),
      );
    }

    // =========================
    // LEFT LIST
    // =========================
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
            const Text(
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
                    ? const Center(
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

    // =========================
    // RIGHT DETAILS
    // =========================
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
            const Text(
              'Caso a ser atendido',
              style: TextStyle(
                color: ink,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Obx(() {
                    final s = controller.solicitation.value;
                    final has = s?.id != null && s!.id!.isNotEmpty;

                    if (!has) {
                      return Padding(
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
                      );
                    }

                    final customer = s.customer;
                    final address = s.address;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ===== Cliente =====
                        sectionHeader("Cliente"),

                        editableField(
                          label: "Nome",
                          value: customer?.name ?? "",
                          hint: "Digite o nome",
                          icon: Icons.person,
                          onChanged: (v) {
                            if (customer != null) customer.name = v;
                          },
                        ),

                        editableField(
                          label: "CPF/CNPJ",
                          value: customer?.cpf ?? "",
                          hint: "Digite o CPF/CNPJ",
                          icon: Icons.badge_outlined,
                          onChanged: (v) {
                            if (customer != null) customer.cpf = v;
                          },
                        ),

                        editableField(
                          label: "E-mail",
                          value: customer?.email ?? "",
                          hint: "Digite o e-mail",
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (v) {
                            if (customer != null) customer.email = v;
                          },
                        ),

                        editableField(
                          label: "Telefone",
                          value: customer?.phone ?? "",
                          hint: "Digite o telefone",
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          onChanged: (v) {
                            if (customer != null) customer.phone = v;
                          },
                        ),

                        const SizedBox(height: 6),

                        // ===== Endereço =====
                        sectionHeader("Endereço"),

                        editableField(
                          label: "Rua",
                          value: address?.street ?? "",
                          hint: "Digite a rua",
                          icon: Icons.location_on_outlined,
                          onChanged: (v) {
                            if (address != null) address.street = v;
                          },
                        ),

                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: editableField(
                                label: "Bairro",
                                value: address?.neighborhood ?? "",
                                hint: "Digite o bairro",
                                icon: Icons.map_outlined,
                                onChanged: (v) {
                                  if (address != null) address.neighborhood = v;
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: editableField(
                                label: "Número",
                                value: (address?.number ?? "").toString(),
                                hint: "Nº",
                                icon: Icons.pin_outlined,
                                //keyboardType: TextInputType.number,
                                onChanged: (v) {
                                  // mantém só visual (front)
                                  if (address != null) {
                                    // se number for int, tente parse
                                    address.number = v;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        editableField(
                          label: "Cidade",
                          value: address?.city ?? "",
                          hint: "Digite a cidade",
                          icon: Icons.location_city_outlined,
                          onChanged: (v) {
                            if (address != null) address.city = v;
                          },
                        ),

                        editableField(
                          label: "CEP",
                          value: (address?.zipCode ?? ""),
                          hint: "Digite o CEP",
                          icon: Icons.markunread_mailbox_outlined,
                          keyboardType: TextInputType.number,
                          onChanged: (v) {
                            if (address != null) {
                              // soporta ambos nombres
                               address.zipCode = v;
                            }
                          },
                        ),

                        const SizedBox(height: 6),

                        // ===== Serviços =====
                        sectionHeader("Serviços"),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.06),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(.12),
                            ),
                          ),
                          child: Text(
                            (s.service?.trim().isNotEmpty ?? false)
                                ? s.service!.trim()
                                : "-",
                            style: TextStyle(
                              color: Colors.white.withOpacity(.85),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        if (s.services != null)
                          ...s.services!.map(
                            (sv) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                "• ${sv.name ?? "-"}",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.80),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 10),

                        // ===== Documentos =====
                        if (s.service == 'transfer' || s.service == 'tranfer') ...[
                          sectionHeader("Documentos"),
                          doc_widget.Document(),
                          const SizedBox(height: 10),
                        ],

                        // ===== Botones =====
                        if (s.status == SolicitationStatus.pending)
                          _ActionButton(
                            label: 'Iniciar atendimento',
                            icon: Icons.play_arrow_rounded,
                            baseColor: primario,
                            onPressed: () => controller.startSolicitation(),
                          )
                        else if (s.status == SolicitationStatus.processing)
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
                              color: Colors.white.withOpacity(.10),
                            ),
                          ),
                          child: Text(
                            s.status == SolicitationStatus.done
                                ? 'Concluído'
                                : s.status == SolicitationStatus.processing
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
                    );
                  }),
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
            icon: Icon(
              Icons.person_3_rounded,
              color: Colors.white.withOpacity(.9),
            ),
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
