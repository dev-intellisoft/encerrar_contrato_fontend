import 'package:flutter/material.dart';

class Success extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.check_circle_outline, color: Colors.green, size: 60,),
        SizedBox(height: 20,),
        Text('Recebemos seu pagamento com successo', textAlign: TextAlign.center,),
        SizedBox(height: 10,),
        Text('Pedimos por gentileza que arguarde as próximas etapas da sua solicitação', textAlign: TextAlign.center,),
        SizedBox(height: 10,),
        Text('Manteremos você informado do progresso de solicitação a através do e-mail informado.', textAlign: TextAlign.center,),
        SizedBox(height: 20,),
        Text('Obrigado!', textAlign: TextAlign.center,)
      ],
    );
  }
  
}