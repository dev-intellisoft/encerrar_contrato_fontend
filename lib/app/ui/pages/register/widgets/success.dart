import 'package:flutter/material.dart';

class Success extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ink = Colors.white.withOpacity(.92);
    final muted = Colors.white.withOpacity(.78);
    return Column(
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: 60,
        ),
        const SizedBox(height: 20),
        Text(
          'Recebemos seu pagamento com sucesso',
          textAlign: TextAlign.center,
          style: TextStyle(color: ink, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Text(
          'Pedimos por gentileza que aguarde as próximas etapas da sua solicitação',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted, height: 1.35),
        ),
        const SizedBox(height: 10),
        Text(
          'Manteremos você informado do progresso da solicitação através do e-mail informado.',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted, height: 1.35),
        ),
        const SizedBox(height: 20),
        Text(
          'Obrigado!',
          textAlign: TextAlign.center,
          style: TextStyle(color: ink, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
  
}
