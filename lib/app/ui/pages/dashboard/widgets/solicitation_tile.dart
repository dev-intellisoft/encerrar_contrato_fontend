import 'package:encerrar_contrato/app/widgets/pending.dart';
import 'package:encerrar_contrato/app/widgets/processing.dart';
import 'package:flutter/material.dart';

import '../../../../models/service_model.dart';
import '../../../../models/solicitation_model.dart';
import '../../../../widgets/agency_logo.dart';
import '../../../../widgets/done.dart';

class SolicitationTile extends StatelessWidget {
  final Function(Solicitation)? onTap;
  final Solicitation solicitation;
  final bool isSelected;

  const SolicitationTile({
    super.key,
    required this.solicitation,
    this.onTap,
    this.isSelected = false,
  });

  String? _createdDateLabel() {
    final date = solicitation.createdAt;
    if (date == null) return null;
    final local = date.toLocal();
    final dd = local.day.toString().padLeft(2, '0');
    final mm = local.month.toString().padLeft(2, '0');
    final yyyy = local.year.toString();
    final hh = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    return '$dd/$mm/$yyyy as $hh:$min';
  }

  ({String label, Color color}) _serviceBadge() {
    final service = solicitation.service.trim().toLowerCase();

    if (service == 'transfer' || service == 'tranfer') {
      return (
        label: 'Transferencia',
        color: const Color(0xFF36BAFE),
      );
    }

    if (service == 'close') {
      return (
        label: 'Encerramento',
        color: const Color(0xFFF59E0B),
      );
    }

    return (
      label: 'Solicitacao',
      color: Colors.white,
    );
  }

  ({String label, Color color, bool isAgency}) _originBadge() {
    final agency = (solicitation.agency ?? '').trim().toLowerCase();
    final isAgencySource = agency.isNotEmpty && agency != 'encerrar';

    if (isAgencySource) {
      return (
        label: 'Imobiliaria',
        color: const Color(0xFF36BAFE),
        isAgency: true,
      );
    }

    return (
      label: 'Cliente',
      color: const Color(0xFF22C55E),
      isAgency: false,
    );
  }

  List<Service> _selectedItems() => solicitation.displayServices();

  ({String title, String subtitle, Color color}) _serviceSpotlight() {
    final selectedItems = _selectedItems();
    final badge = _serviceBadge();

    if (selectedItems.isEmpty) {
      return (
        title: badge.label,
        subtitle: 'Empresa nao informada',
        color: badge.color,
      );
    }

    final first = selectedItems.first;
    final name = (first.name ?? '').trim();
    final company = (first.companyName ?? '').trim();
    final extraCount = selectedItems.length - 1;
    final extraLabel = extraCount > 0 ? ' +$extraCount' : '';

    return (
      title: '${name.isEmpty ? badge.label : name}$extraLabel',
      subtitle: company.isEmpty ? 'Empresa nao informada' : company,
      color: badge.color,
    );
  }

  ({
    String label,
    Color color,
    IconData icon,
    bool show,
  }) _paymentBadge(bool isAgencySource) {
    if (isAgencySource) {
      return (
        label: 'Sem pagamento',
        color: const Color(0xFF36BAFE),
        icon: Icons.business_center_rounded,
        show: true,
      );
    }

    final paymentStatus = solicitation.paymentStatus.trim().toLowerCase();

    if (paymentStatus == 'paid') {
      return (
        label: 'Pago',
        color: const Color(0xFF22C55E),
        icon: Icons.verified_rounded,
        show: true,
      );
    }

    if (paymentStatus == 'pending' ||
        paymentStatus == 'awaiting_payment' ||
        paymentStatus.isEmpty) {
      return (
        label: 'Pendente de pagamento',
        color: const Color(0xFFF59E0B),
        icon: Icons.pending_actions_rounded,
        show: true,
      );
    }

    return (
      label: 'Falha no pagamento',
      color: const Color(0xFFEF4444),
      icon: Icons.error_outline_rounded,
      show: true,
    );
  }

  Widget _buildBadge({
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.42)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 10,
          letterSpacing: .2,
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    if (solicitation.status == SolicitationStatus.done) {
      return Tooltip(message: 'Concluido', child: Done());
    }
    if (SolicitationStatus.processing == solicitation.status) {
      return Tooltip(message: 'Iniciado', child: Processing());
    }
    return Tooltip(message: 'Nao iniciado', child: Pending());
  }

  @override
  Widget build(BuildContext context) {
    final badge = _serviceBadge();
    final origin = _originBadge();
    final payment = _paymentBadge(origin.isAgency);
    final createdDate = _createdDateLabel();
    final serviceSpotlight = _serviceSpotlight();
    final statusIndicator = _buildStatusIndicator();

    return _HoverTile(
      selected: isSelected,
      agencySource: origin.isAgency,
      onTap: () => onTap?.call(solicitation),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 360;

          Widget paymentIcon() {
            if (!payment.show) return const SizedBox.shrink();
            return Tooltip(
              message: payment.label,
              child: Container(
                width: compact ? 34 : 36,
                height: compact ? 34 : 36,
                decoration: BoxDecoration(
                  color: payment.color.withOpacity(.14),
                  shape: BoxShape.circle,
                  border: Border.all(color: payment.color.withOpacity(.42)),
                ),
                child: Icon(
                  payment.icon,
                  size: 18,
                  color: payment.color,
                ),
              ),
            );
          }

          Widget logoIcon() {
            return Tooltip(
              message: solicitation.agency,
              child: AgencyLogo(imagePath: solicitation.agencyLogo ?? ""),
            );
          }

          Widget contentColumn() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildBadge(label: badge.label, color: badge.color),
                    _buildBadge(label: origin.label, color: origin.color),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  solicitation.customer?.name ?? "-",
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
                  "${solicitation.address?.street ?? "-"}, "
                  "${solicitation.address?.number ?? "-"}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.white.withOpacity(.78),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${solicitation.address?.city ?? "-"}, "
                  "${solicitation.address?.state ?? "-"}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(.60),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: serviceSpotlight.color.withOpacity(.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: serviceSpotlight.color.withOpacity(.30),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.apartment_outlined,
                        color: serviceSpotlight.color,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              serviceSpotlight.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(.96),
                                fontWeight: FontWeight.w900,
                                fontSize: 11.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              serviceSpotlight.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(.72),
                                fontWeight: FontWeight.w700,
                                fontSize: 10.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        createdDate != null
                            ? 'Enviado em $createdDate'
                            : 'Data/hora nao registradas',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.5,
                          height: 1.25,
                          color: Colors.white.withOpacity(
                            createdDate != null ? .56 : .42,
                          ),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (compact) ...[
                      const SizedBox(width: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          paymentIcon(),
                          if (payment.show) const SizedBox(width: 8),
                          logoIcon(),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            );
          }

          if (compact) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                statusIndicator,
                const SizedBox(width: 10),
                Expanded(child: contentColumn()),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              statusIndicator,
              const SizedBox(width: 12),
              Expanded(child: contentColumn()),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  paymentIcon(),
                  if (payment.show) const SizedBox(height: 10),
                  logoIcon(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HoverTile extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool selected;
  final bool agencySource;

  const _HoverTile({
    required this.child,
    this.onTap,
    this.selected = false,
    this.agencySource = false,
  });

  @override
  State<_HoverTile> createState() => _HoverTileState();
}

class _HoverTileState extends State<_HoverTile> {
  bool _hover = false;
  bool _down = false;

  static const primario = Color(0xFF5E17EB);
  static const bgCard = Color(0xFF0B0B12);
  static const agencyBlue = Color(0xFF0E5BFF);

  @override
  Widget build(BuildContext context) {
    final Color bg = widget.selected
        ? primario.withOpacity(.20)
        : widget.agencySource && (_hover || _down)
            ? Colors.white.withOpacity(.10)
            : widget.agencySource
                ? agencyBlue.withOpacity(.16)
                : _down
                    ? bgCard.withOpacity(.85)
                    : _hover
                        ? bgCard.withOpacity(.95)
                        : bgCard;

    final Color borderColor = widget.selected
        ? primario.withOpacity(.95)
        : widget.agencySource && (_hover || _down)
            ? Colors.white.withOpacity(.60)
            : widget.agencySource
                ? agencyBlue.withOpacity(.70)
                : _hover
                    ? primario.withOpacity(.45)
                    : Colors.white.withOpacity(.08);

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
          constraints: const BoxConstraints(minHeight: 132),
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: widget.selected ? 1.8 : 1.0,
            ),
            boxShadow: [
              if (widget.selected)
                BoxShadow(
                  color: primario.withOpacity(.45),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                )
              else if (widget.agencySource)
                BoxShadow(
                  color: agencyBlue.withOpacity(_hover || _down ? .28 : .18),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                )
              else if (_hover || _down)
                BoxShadow(
                  color: primario.withOpacity(.22),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              BoxShadow(
                color: Colors.black.withOpacity(.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: widget.selected ? 4 : 0,
                height: 56,
                margin: EdgeInsets.only(right: widget.selected ? 10 : 0),
                decoration: BoxDecoration(
                  color: primario.withOpacity(.95),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Expanded(child: widget.child),
            ],
          ),
        ),
      ),
    );
  }
}
