import 'package:encerrar_contrato/app/ui/pages/register/widgets/credit_card.dart';
import 'package:encerrar_contrato/app/ui/pages/register/widgets/pix.dart';
import 'package:encerrar_contrato/app/ui/pages/register/widgets/spinner.dart';
import 'package:encerrar_contrato/app/ui/pages/register/widgets/success.dart';
import 'package:encerrar_contrato/app/ui/pages/register/widgets/transfer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:encerrar_contrato/app/controllers/register_controller.dart';
import '../../../widgets/logo.dart';
import 'widgets/close.dart';

class RegisterPage extends GetView<RegisterController> {
  final String agencyId;
  const RegisterPage({super.key, required this.agencyId});

  @override
  Widget build(BuildContext context) {
    controller.solicitation.value.agencyId = agencyId;
    controller.getAgencyLogo(agencyId);
    return Scaffold(
      appBar: AppBar(
        title: Logo(),
        backgroundColor: Color.fromRGBO(255, 131, 33, 1.0),
      ),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) return Spinner();

          if (controller.solicitation.value.id != null &&
              controller.solicitation.value != "") {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (controller.creditCardPaymentResponse.value.status !=
                      'CONFIRMED')
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.solicitation.update(
                                (s) => s!.paymentType = 'pix',
                              ),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color:
                                      controller
                                              .solicitation
                                              .value
                                              .paymentType ==
                                          'pix'
                                      ? Color.fromRGBO(255, 131, 33, 1.0)
                                      : Colors.grey,
                                ),
                                child: Center(
                                  child: Text(
                                    'Pagar com pix',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: controller.setPaymentTypeToCreditCard,
                              child: Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      controller
                                              .solicitation
                                              .value
                                              .paymentType ==
                                          'cc'
                                      ? Color.fromRGBO(255, 131, 33, 1.0)
                                      : Colors.grey,
                                  // color:  Color.fromRGBO(255, 131, 33, 1.0)
                                ),
                                child: Center(
                                  child: Text(
                                    'Pagar com cartão de crédito',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 40),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      // color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Código: ${controller.solicitation.value.id}',
                          style: TextStyle(fontSize: 12),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.green,
                              size: 30,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Recebemos sua solicitação',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        if (controller.creditCardPaymentResponse.value.status ==
                            'CONFIRMED')
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: Colors.green,
                                size: 30,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Recebemos seu pagamento',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: Colors.amber,
                                size: 30,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Prossiga para pagamento',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  if (controller.solicitation.value.paymentType == "pix") PIX(),
                  if (controller.solicitation.value.paymentType == "cc")
                    if (controller.creditCardPaymentResponse.value.status ==
                        'CONFIRMED')
                      Success()
                    else
                      CreditCard(),
                ],
              ),
            );
          }

          return Column(
            children: [
              Text(controller.solicitation.value.service),
              SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.solicitation.update(
                          (s) => s!.service = 'close',
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color:
                                controller.solicitation.value.service == 'close'
                                ? Color.fromRGBO(255, 131, 33, 1.0)
                                : Colors.grey,
                          ),
                          child: Center(
                            child: Text(
                              'Encerrar Contrato',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.solicitation.update(
                          (s) => s!.service = 'transfer',
                        ),
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                controller.solicitation.value.service ==
                                    'transfer'
                                ? Color.fromRGBO(255, 131, 33, 1.0)
                                : Colors.grey,
                          ),
                          child: Center(
                            child: Text(
                              'Tranferir Contrato',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.solicitation.value.service == "close") CloseForm(),
              if (controller.solicitation.value.service == "transfer")
                TransferForm(),
            ],
          );
        }),
      ),
    );
  }
}
