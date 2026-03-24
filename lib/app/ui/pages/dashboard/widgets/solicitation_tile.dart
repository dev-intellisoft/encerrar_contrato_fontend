import 'package:encerrar_contrato/app/widgets/pending.dart';
import 'package:encerrar_contrato/app/widgets/processing.dart';
import 'package:flutter/material.dart';
import '../../../../models/solicitation_model.dart';
import '../../../../widgets/done.dart';
import '../../../../widgets/agency_logo.dart';

class SolicitationTile extends StatelessWidget {
  final Function(Solicitation)? onTap;
  final Solicitation solicitation;

  // ✅ el padre decide si está seleccionado
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
    return '$dd/$mm/$yyyy às $hh:$min';
  }

  ({String label, Color color}) _serviceBadge() {
    final service = (solicitation.service).trim().toLowerCase();

    if (service == 'transfer' || service == 'tranfer') {
      return (
        label: 'Transferencia',
        color: const Color(0xFF36BAFE),
      );
    }

    if (service == 'close') {
      return (
        label: 'Encerrar',
        color: const Color(0xFFF59E0B),
      );
    }

    return (
      label: 'Solicitacao',
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final badge = _serviceBadge();
    final createdDate = _createdDateLabel();
    final isAgencySource =
        (solicitation.agency ?? '').isNotEmpty &&
        (solicitation.agency ?? '').toLowerCase() != 'encerrar';

    return _HoverTile(
      selected: isSelected,
      agencySource: isAgencySource,
      onTap: () => onTap?.call(solicitation),
      child: Row(
        children: [
          solicitation.status == SolicitationStatus.done
              ? Tooltip(message: 'Concluído', child: Done())
              : SolicitationStatus.processing == solicitation.status
              ? Tooltip(message: 'Iniciado', child: Processing())
              : Tooltip(message: 'Não iniciado', child: Pending()),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: badge.color.withOpacity(.16),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: badge.color.withOpacity(.42)),
                      ),
                      child: Text(
                        badge.label,
                        style: TextStyle(
                          color: badge.color,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                          letterSpacing: .2,
                        ),
                      ),
                    ),
                    if (isAgencySource)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF36BAFE).withOpacity(.16),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: const Color(0xFF36BAFE).withOpacity(.42),
                          ),
                        ),
                        child: const Text(
                          'Imobiliaria',
                          style: TextStyle(
                            color: Color(0xFF36BAFE),
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                            letterSpacing: .2,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  solicitation.customer?.name ?? "-",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${solicitation.address?.street ?? "-"}, "
                  "${solicitation.address?.number ?? "-"}, "
                  "${solicitation.address?.city ?? "-"}, "
                  "${solicitation.address?.state ?? "-"}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(.70),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (createdDate != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Enviado em $createdDate',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Colors.white.withOpacity(.56),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 2),
                  Text(
                    'Data/hora não registradas',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Colors.white.withOpacity(.42),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (solicitation.paymentType.toLowerCase() == 'pix')
            Tooltip(
              message: solicitation.paymentStatus.toLowerCase() == 'paid'
                  ? 'Pago'
                  : 'Pendente',
              child: Icon(Icons.monetization_on, color: Colors.white),
            )
          else if (solicitation.paymentType.toLowerCase() == 'credit_card')
            Tooltip(
              message: solicitation.paymentStatus.toLowerCase() == 'paid'
                  ? 'Pago'
                  : 'Pendente',
              child: Icon(Icons.credit_card_outlined, color: Colors.white),
            ),
          const SizedBox(width: 50),
          Tooltip(
            message: solicitation.agency,
            child: AgencyLogo(imagePath: solicitation.agencyLogo ?? ""),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// Hover + Pressed + Selected (permanente)
// =====================================================
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
    // ✅ Si está seleccionado, SIEMPRE queda marcado
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
          height: 92,
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
            children: [
              // ✅ Barra lateral que deja CLARO que está seleccionado
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: widget.selected ? 4 : 0,
                height: 38,
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
