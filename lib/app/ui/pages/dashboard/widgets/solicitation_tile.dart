import 'package:encerrar_contrato/app/widgets/pending.dart';
import 'package:encerrar_contrato/app/widgets/processing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/solicitation_model.dart';
import '../../../../widgets/done.dart';
import '../../../../widgets/agency_logo.dart';

class SolicitationTile extends GetView {
  Function(Solicitation)? onTap;
  final Solicitation solicitation;
  SolicitationTile({super.key, required this.solicitation, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(solicitation),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color(0xFF138ED7),
          border: Border.all(color: Color(0xFF171717), width: 1.5),
        ),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            solicitation.status == SolicitationStatus.done
                ? Tooltip(message: 'Concluído', child: Done())
                : SolicitationStatus.processing == solicitation.status
                ? Tooltip(message: 'Iniciado', child: Processing())
                : Tooltip(message: 'Não iniciado', child: Pending()),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${solicitation.customer!.name}',
                    style: TextStyle(color: Colors.white),
                  ),

                  Text(
                    '${solicitation.address!.street}, ${solicitation.address!.number}, ${solicitation.address!.state}',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
            Row(children: [AgencyLogo(imagePath: solicitation.agencyLogo!)]),
          ],
        ),
      ),
    );
  }
}
