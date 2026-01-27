import 'dart:convert';

import 'package:encerrar_contrato/app/controllers/register_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PIX extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          if (controller.pixResponse.value.success == true) {
            return Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.green, width: 1),
              ),
              child: Column(
                children: [
                  Text('Scaneie o código QR para pagar'),
                  Image.memory(
                    base64Decode(controller.pixResponse.value.encodedImage!),
                    width: 200,
                    height: 200,
                  ),
                  Text('Ou copie e cole o código abaixo'),
                  SizedBox(height: 10),
                  ObxValue(
                    (copied) => GestureDetector(
                      onTap: () {
                        copied.value = !copied.value;
                        Clipboard.setData(
                          ClipboardData(
                            text: controller.pixResponse.value.payload!,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Text(controller.pixResponse.value.payload!),

                          if (copied.value)
                            Column(
                              children: [
                                Icon(Icons.check_circle_rounded),
                                Text('Copiado'),
                              ],
                            )
                          else
                            Column(
                              children: [Icon(Icons.copy), Text('Copiar')],
                            ),
                        ],
                      ),
                    ),
                    false.obs,
                  ),
                ],
              ),
            );
          }
          return GestureDetector(
            onTap: controller.processPIXPayment,
            child: Container(
              padding: EdgeInsets.all(20),
              color: Color(0xFF0099FF),
              child: Text(
                'Gerar pagamento com pix',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }),
      ],
    );
  }
}
