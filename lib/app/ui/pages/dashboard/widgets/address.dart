import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/dashboard_controller.dart';

class Address extends GetWidget<DashboardController> {
  const Address({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text('Endereço'),
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: controller.solicitation.value?.address!.street,
                decoration: InputDecoration(
                  labelText: 'Rua',
                  hintText: 'Digite a rua',
                ),
                readOnly: true,
              ),
            ),
            Container(
              width: 100,
              margin: EdgeInsets.only(left: 10),
              child: TextFormField(
                initialValue: controller.solicitation.value?.address!.number,
                decoration: InputDecoration(
                  labelText: 'Número',
                  hintText: 'Digite o número',
                ),
                readOnly: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        TextFormField(
          initialValue: controller.solicitation.value?.address!.neighborhood,
          decoration: InputDecoration(
            labelText: 'Bairro',
            hintText: 'Digite o bairro',
          ),
          readOnly: true,
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: controller.solicitation.value?.address!.city,
                decoration: InputDecoration(
                  labelText: 'Cidade',
                  hintText: 'Digite a cidade',
                ),
                readOnly: true,
              ),
            ),
            Container(
              width: 100,
              margin: EdgeInsets.only(left: 10),
              child: TextFormField(
                initialValue: controller.solicitation.value?.address!.state,
                decoration: InputDecoration(
                  labelText: 'Estado',
                  hintText: 'Digite o estado',
                ),
                readOnly: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        TextFormField(
          initialValue: controller.solicitation.value?.address!.zipCode,
          decoration: InputDecoration(
            labelText: 'CEP',
            hintText: 'Digite o cep',
          ),
          readOnly: true,
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
