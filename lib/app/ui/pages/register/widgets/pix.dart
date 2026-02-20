import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:encerrar_contrato/app/controllers/register_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PIX extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          if (controller.pixResponse.value.success == true) {
            final channel = WebSocketChannel.connect(
              Uri.parse(
                '${dotenv.env['WEBSOCKET']}/ws/${controller.solicitation.value.id}',
              ),
            );
            channel.stream.listen((message) {
              if (message.contains('PAYMENT_CONFIRMED')) {
                print("Pagamento confirmado");
                controller.pixResponse.update((e) => e!.paid = true);
                channel.sink.close();
                // Get.back();
              }
            });

            if (controller.pixResponse.value.paid == true) {
              return Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: Column(
                  children: [
                    Text(
                      'Pagamento confirmado',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              );
            }

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
                          Text(
                            controller.pixResponse.value.payload!,
                            style: TextStyle(color: Colors.white),
                          ),

                          if (copied.value)
                            Column(
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Copiado',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                Icon(Icons.copy, color: Colors.white),
                                Text(
                                  'Copiar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
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
