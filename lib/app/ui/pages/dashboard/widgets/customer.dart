import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/dashboard_controller.dart';

class Customer extends GetView<DashboardController> {
  const Customer({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text('Cliente'),

      children: [
        Row(
          children: [
            Text(
              'Forma de pagemento: ' +
                  controller.solicitation.value!.paymentType!,
            ),
            SizedBox(width: 10),

            Text(
              'Tipo de solicitação: ' +
                  (controller.solicitation.value!.service! == 'close'
                      ? 'Encerramento'
                      : 'Transferência'),
            ),
          ],
        ),
        SizedBox(height: 10),
        TextFormField(
          initialValue: controller.solicitation.value?.customer!.name,
          decoration: InputDecoration(
            labelText: 'Nome',
            hintText: 'Digite o nome',
          ),
          readOnly: true,
        ),
        SizedBox(height: 10),
        TextFormField(
          initialValue: controller.solicitation.value?.customer!.cpf,
          decoration: InputDecoration(
            labelText: 'CPF/CNPJ',
            hintText: 'Digite o CPF/CNPJ',
          ),
          readOnly: true,
        ),
        SizedBox(height: 10),
        TextFormField(
          initialValue: controller.solicitation.value?.customer!.email,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Digite o email',
          ),
          readOnly: true,
        ),
        SizedBox(height: 10),
        TextFormField(
          initialValue: controller.solicitation.value?.customer!.phone,
          decoration: InputDecoration(
            labelText: 'Telefone',
            hintText: 'Digite o telefone',
          ),
          readOnly: true,
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
