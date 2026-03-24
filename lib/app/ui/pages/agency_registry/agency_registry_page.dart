import 'package:encerrar_contrato/app/controllers/agency_controller.dart';
import 'package:encerrar_contrato/app/ui/pages/register/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/logo.dart';
import 'widgets/close.dart';
import 'widgets/transfer.dart';

class AgencyRegistryPage extends GetView<AgencyController> {
  const AgencyRegistryPage({super.key});

  static const _primary = Color(0xFF5E17EB);
  static const _secondary = Color(0xFF2576FB);
  static const _accent = Color(0xFF36BAFE);
  static const _bg = Color(0xFF070710);
  static const _bgCard = Color(0xFF0B0B12);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final maxWidth = (width * 0.40).clamp(360.0, 720.0);
    final subtle = Colors.white.withOpacity(.74);

    Widget sectionHeader(String title) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
              height: 10,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _accent,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withOpacity(.97),
                fontWeight: FontWeight.w900,
                fontSize: 13,
                letterSpacing: .9,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white.withOpacity(.16),
              ),
            ),
          ],
        ),
      );
    }

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
          color: _bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(.12)),
          boxShadow: [
            BoxShadow(
              color: _primary.withOpacity(.10),
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

    Widget submissionCard({String? code}) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _bgCard,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _accent.withOpacity(.38), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.35),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: _accent.withOpacity(.14),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: _accent,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Solicitacao enviada ao master',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.white.withOpacity(.96),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Esse fluxo termina aqui. Os dados foram recebidos e seguem para atendimento sem etapa de pagamento.',
              style: TextStyle(
                color: Colors.white.withOpacity(.78),
                height: 1.4,
              ),
            ),
            if ((code ?? '').isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(.10)),
                ),
                child: Text(
                  'Protocolo: $code',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.92),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Logo(),
        backgroundColor: _bgCard,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(.95)),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bg, Color.lerp(_bg, _secondary, .06)!, _bg],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              left: -120,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _primary.withOpacity(.14),
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
                  color: _accent.withOpacity(.10),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Spinner();
                  }

                  final hasSubmission =
                      (controller.solicitation.value.id ?? '').isNotEmpty;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (hasSubmission)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                submissionCard(
                                  code: controller.solicitation.value.protocol
                                      ?.toString(),
                                ),
                                const SizedBox(height: 14),
                                ElevatedButton(
                                  onPressed: controller.New,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    'Nova solicitacao',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () => Get.back(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: _primary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    'Voltar',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                sectionHeader('Tipo de solicitacao'),
                                premiumSwitch(
                                  leftText: 'Encerrar Contrato',
                                  rightText: 'Transferir Contrato',
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
                                if (controller.solicitation.value.service ==
                                    'close')
                                  CloseForm(),
                                if (controller.solicitation.value.service ==
                                    'transfer')
                                  TransferForm(),
                                const SizedBox(height: 12),
                                Text(
                                  'Encerrar Contrato • Imobiliaria',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: subtle,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
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

  static const _primary = Color(0xFF5E17EB);

  @override
  Widget build(BuildContext context) {
    final background = widget.active
        ? _primary
        : _down
            ? Colors.white.withOpacity(.12)
            : _hover
                ? Colors.white.withOpacity(.11)
                : Colors.white.withOpacity(.09);

    final border = widget.active
        ? _primary.withOpacity(.85)
        : Colors.white.withOpacity(.14);

    final textColor = widget.active
        ? Colors.white
        : Colors.white.withOpacity(.92);

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
            color: background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
            boxShadow: [
              if (widget.active || _hover || _down)
                BoxShadow(
                  color: _primary.withOpacity(widget.active ? .28 : .18),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: textColor, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
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
