import 'package:encerrar_contrato/app/ui/pages/register/widgets/credit_card.dart';
import 'package:encerrar_contrato/app/ui/pages/register/widgets/pix.dart';
import 'package:encerrar_contrato/app/ui/pages/register/widgets/spinner.dart';
import 'package:encerrar_contrato/app/ui/pages/register/widgets/success.dart';
import 'package:encerrar_contrato/app/ui/pages/register/widgets/transfer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:encerrar_contrato/app/controllers/register_controller.dart';
import '../../../widgets/logo.dart';
import 'widgets/close.dart';

class RegisterPage extends GetView<RegisterController> {
  final String agencyId;
  const RegisterPage({super.key, required this.agencyId});

  @override
  Widget build(BuildContext context) {
    controller.solicitation.value.agencyId = agencyId;
    controller.getAgencyLogo(agencyId);

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
    final maxW = (w * 0.40).clamp(360.0, 720.0);

    InputDecoration inputDec({required String hint, required IconData icon}) {
      return InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(.55)),
        prefixIcon: Icon(icon, color: claro),
        filled: true,
        fillColor: Colors.white.withOpacity(.06),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
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
              child: Container(height: 1, color: Colors.white.withOpacity(.12)),
            ),
          ],
        ),
      );
    }

    // ✅ Switch premium tipo "segmented"
    Widget premiumSwitch({
      required String leftText,
      required String rightText,
      required bool leftActive,
      required VoidCallback onLeft,
      required VoidCallback onRight,
      IconData? leftIcon,
      IconData? rightIcon,
    }) {
      return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: bg2,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(.08)),
          boxShadow: [
            BoxShadow(
              color: primario.withOpacity(.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _SegmentButton(
                label: leftText,
                icon: leftIcon,
                active: leftActive,
                onTap: onLeft,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SegmentButton(
                label: rightText,
                icon: rightIcon,
                active: !leftActive,
                onTap: onRight,
              ),
            ),
          ],
        ),
      );
    }

    // ✅ Card “status” premium
    Widget statusCard({required String code, required bool paidConfirmed}) {
      final ok = paidConfirmed;
      final Color accent = ok ? Colors.green : Colors.amber;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg2,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: accent.withOpacity(.55), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.35),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: accent.withOpacity(.12),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Código: $code',
              style: TextStyle(
                color: Colors.white.withOpacity(.70),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Recebemos sua solicitação',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  ok ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                  color: ok ? Colors.green : Colors.amber,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    ok ? 'Recebemos seu pagamento' : 'Prossiga para pagamento',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: ok ? Colors.green : Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Logo(),
        backgroundColor: bg2,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(.9)),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bg, Color.lerp(bg, secundario, .06)!, bg],
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
                  color: primario.withOpacity(.14),
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
                  color: claro.withOpacity(.10),
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: Obx(() {
                  if (controller.isLoading.value) return Spinner();

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxW),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ===== PÓS-CRIADO: pagamento + status =====
                          if (controller.solicitation.value.id != null &&
                              controller.solicitation.value != "")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                sectionHeader("Pagamento"),

                                // Switch pix / cc só se não confirmado (mantive tua regra)
                                if (controller
                                        .creditCardPaymentResponse
                                        .value
                                        .status !=
                                    'CONFIRMED')
                                  premiumSwitch(
                                    leftText: "Pagar com PIX",
                                    rightText: "Cartão de crédito",
                                    leftActive:
                                        controller
                                            .solicitation
                                            .value
                                            .paymentType ==
                                        'pix',
                                    leftIcon: Icons.qr_code_rounded,
                                    rightIcon: Icons.credit_card_rounded,
                                    onLeft: () => controller.solicitation
                                        .update((s) => s!.paymentType = 'pix'),
                                    onRight:
                                        controller.setPaymentTypeToCreditCard,
                                  ),

                                const SizedBox(height: 14),

                                statusCard(
                                  code: "${controller.solicitation.value.id}",
                                  paidConfirmed:
                                      controller
                                          .creditCardPaymentResponse
                                          .value
                                          .status ==
                                      'CONFIRMED',
                                ),

                                const SizedBox(height: 16),

                                // Conteúdo pagamento
                                if (controller.solicitation.value.paymentType ==
                                    "pix")
                                  PIX(),

                                if (controller.solicitation.value.paymentType ==
                                    "cc")
                                  if (controller
                                          .creditCardPaymentResponse
                                          .value
                                          .status ==
                                      'CONFIRMED')
                                    Success()
                                  else
                                    CreditCard(),

                                const SizedBox(height: 12),
                                Text(
                                  "Encerrar Contrato • Registro",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(.35),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          else
                            // ===== ANTES DE CRIAR: escolher tipo + forms =====
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                sectionHeader("Tipo de solicitação"),

                                // type of registration switch (estilo premium)
                                premiumSwitch(
                                  leftText: "Encerrar Contrato",
                                  rightText: "Transferir Contrato",
                                  leftActive:
                                      controller.solicitation.value.service ==
                                      'close',
                                  leftIcon: Icons.lock_outline_rounded,
                                  rightIcon: Icons.swap_horiz_rounded,
                                  onLeft: () => controller.solicitation.update(
                                    (s) => s!.service = 'close',
                                  ),
                                  onRight: () => controller.solicitation.update(
                                    (s) => s!.service = 'transfer',
                                  ),
                                ),

                                const SizedBox(height: 14),

                                Text(
                                  '${controller.solicitation.value.service} selected',
                                  style: const TextStyle(color: Colors.white),
                                ),

                                // Forms (mantidos)
                                if (controller.solicitation.value.service ==
                                    "close")
                                  CloseForm(),
                                if (controller.solicitation.value.service ==
                                    "transfer")
                                  TransferForm(),
                                const SizedBox(height: 12),
                                Text(
                                  "Encerrar Contrato • Registro",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(.35),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// Segment Button (hover + pressed + active) - SOLO FRONT
// =====================================================
class _SegmentButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final bool active;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.label,
    required this.active,
    required this.onTap,
    this.icon,
  });

  @override
  State<_SegmentButton> createState() => _SegmentButtonState();
}

class _SegmentButtonState extends State<_SegmentButton> {
  bool _hover = false;
  bool _down = false;

  static const primario = Color(0xFF5E17EB);

  @override
  Widget build(BuildContext context) {
    final Color bg = widget.active
        ? primario
        : _down
        ? Colors.white.withOpacity(.10)
        : _hover
        ? Colors.white.withOpacity(.08)
        : Colors.white.withOpacity(.06);

    final Color border = widget.active
        ? primario.withOpacity(.75)
        : Colors.white.withOpacity(.10);

    final Color txt = widget.active
        ? Colors.white
        : Colors.white.withOpacity(.85);

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
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          height: 46,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
            boxShadow: [
              if (widget.active || _hover || _down)
                BoxShadow(
                  color: primario.withOpacity(widget.active ? .28 : .18),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: txt, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: txt,
                  fontWeight: FontWeight.w900,
                  fontSize: 12.5,
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
