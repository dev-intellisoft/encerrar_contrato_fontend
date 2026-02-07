import 'package:encerrar_contrato/app/widgets/pending.dart';
import 'package:encerrar_contrato/app/widgets/processing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    return _HoverTile(
      selected: isSelected,
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
                  "${solicitation.address?.state ?? "-"}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(.70),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          AgencyLogo(imagePath: solicitation.agencyLogo ?? ""),
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

  const _HoverTile({
    required this.child,
    this.onTap,
    this.selected = false,
  });

  @override
  State<_HoverTile> createState() => _HoverTileState();
}

class _HoverTileState extends State<_HoverTile> {
  bool _hover = false;
  bool _down = false;

  static const primario = Color(0xFF5E17EB);
  static const bgCard = Color(0xFF0B0B12);

  @override
  Widget build(BuildContext context) {
    // ✅ Si está seleccionado, SIEMPRE queda marcado
    final Color bg = widget.selected
        ? primario.withOpacity(.20)
        : _down
            ? bgCard.withOpacity(.85)
            : _hover
                ? bgCard.withOpacity(.95)
                : bgCard;

    final Color borderColor = widget.selected
        ? primario.withOpacity(.95)
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
          height: 60,
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
