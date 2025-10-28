import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:encerrar_contrato/app/controllers/register_controller.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../widgets/logo.dart';
import '../../../widgets/logo_imobiliaria.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Logo(),
          backgroundColor: Color.fromRGBO(255, 131, 33, 1.0),
        ),
        body: Center(child: Obx(() {
          if (controller.solicitation.value.id != null && controller.solicitation.value != "") {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 40,),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      // color: Colors.green,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.check_circle_rounded, color: Colors.green, size: 100,),
                        Text('Solicitação criada com sucesso', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green), ),
                        Text('Código: ${controller.solicitation.value.id}'),
                      ],
                    ),
                  ),
                  SizedBox(height: 40,),
                  if(controller.solicitation.value.pix != null)
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    child: Column(
                      children: [
                        Text('Scaneie o código QR para pagar'),
                        Image.memory( base64Decode(controller.solicitation.value.pix!.encodedImage), width: 200, height: 200,),
                        Text('Ou copie e cole o código abaixo'),
                        ObxValue((copied)  => GestureDetector(
                          onTap: () {
                            copied.value = !copied.value;
                            Clipboard.setData(ClipboardData(text: controller.solicitation.value.pix!.payload));
                          },
                          child:Column(
                            children: [
                              Text(controller.solicitation.value.pix!.payload),

                              if(copied.value)
                                Column(
                                  children: [
                                    Icon(Icons.check_circle_rounded,),
                                    Text('Copiado'),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    Icon(Icons.copy),
                                    Text('Copiar'),
                                  ],
                                )
                            ],
                          ),
                        ),  false.obs ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          if(controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 30,),
                Text('Enviando...'),
                Text('Por favor, aguarde isso pode levar alguns minutos...'),
              ],
            ),
          );
          }
          return ListView(
            children: [
              Row(
                children: [LogoImobiliaria(),],
              ),
              Text('Preencha os campos solicitados:'),

              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(
                    onChanged: (text) => controller.solicitation.value.customer!.name = text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      hintText: 'Digite seu nome completo',
                      labelText: 'Nome completo',
                    )
                ),),

              Row(
                children: [
                  Expanded(child: Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: '###.###.###-##',
                            filter: {"#": RegExp(r'[0-9]')}, // only digits allowed
                          )
                        ],
                        onChanged: (text) => controller.solicitation.value.customer!.cpf = text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          labelText: 'CPF',
                        )
                    ),
                  )),
                  Expanded(child: Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: '##/##/####',
                            filter: {"#": RegExp(r'[0-9]')}, // only digits allowed
                          )
                        ],
                        onChanged: (text) => controller.solicitation.value.customer!.birthDate = text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          labelText: 'Data de nascimento',
                        )
                    ),
                  )),
                ],
              ),
              
              Row(
                children: [
                  Expanded(child: Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z0-9@.]+')),
                        ],

                        onChanged: (text) => controller.solicitation.value.customer!.email = text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          labelText: 'Email',
                        )
                    ),
                  )),
                  Expanded(child: Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: '(##) #####-####',
                            filter: {"#": RegExp(r'[0-9]')}, // only digits allowed
                          )
                        ],
                        onChanged: (text) => controller.solicitation.value.customer!.phone = text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          labelText: 'Telefone(Whatsapp)',
                        )
                    ),
                  )),
                ],
              ),

              Text('Endereço:'),
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '##.###-###',
                        filter: {"#": RegExp(r'[0-9]')}, // only digits allowed
                      )
                    ],
                    onChanged: controller.setCep,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      labelText: 'CEP',
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(
                    controller: TextEditingController(text: controller.solicitation.value.address?.street),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      labelText: 'Rua',
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(
                    controller: TextEditingController(text: controller.solicitation.value.address?.neighborhood),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      labelText: 'Bairro',
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                          onChanged: (text) => controller.solicitation.update((s) => s!.address!.number = text),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            labelText: 'Número',
                          )
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                          controller: TextEditingController(
                              text: controller.solicitation.value.address?.state
                          ),
                          onChanged: (text) => controller.solicitation.update((s) => s!.address!.state = text),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            labelText: 'UF',
                          )
                      ),
                    )
                  ],
                ),
              ),
              Text('Serviço a encerrar:'),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Checkbox(
                          value: controller.solicitation.value.water,
                          onChanged: (value) => controller.solicitation.update((s) => s!.water = !s.water)
                      ),
                      Text('Agua')
                    ],),
                    Container(
                      width: 300,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child:        TextFormField(
                          onChanged: (text) => controller.solicitation.update((s) => s!.waterCarrier = text),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            labelText: 'Informa a empresa prestadora do serviço',
                          )
                      ),
                    ),

                    Row( children: [
                      Checkbox(
                          value: controller.solicitation.value.power,
                          onChanged: (value) => controller.solicitation.update((s) => s!.power = !s.power)
                      ),
                      Text('Energia')
                    ],),
                    Container(
                      width: 300,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child:        TextFormField(
                          onChanged: (text) => controller.solicitation.update((s) => s!.powerCarrier = text),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            labelText: 'Informa a empresa prestadora do serviço',
                          )
                      ),
                    ),


                    Row( children: [
                      Checkbox(
                          value: controller.solicitation.value.gas,
                          onChanged: (value) => controller.solicitation.update((s) => s!.gas = !s.gas)
                      ),
                      Text('Gas')
                    ],),
                    Container(
                        width: 300,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child:        TextFormField(
                            onChanged: (text) => controller.solicitation.update((s) => s!.gasCarrier = text),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              labelText: 'Informa a empresa prestadora do serviço',
                            )
                        )
                    )
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: () => Get.dialog(AlertDialog(
                  title: Text('Termo de Consentimento.', textAlign: TextAlign.center,),
                  content: ObxValue((agree)=>
                      Column(
                        children: [
                          Text('Termo de Consentimento.', textAlign: TextAlign.center,),
                          Text('Autorizo o envio dos meus dados pessoais, conforme informado neste formulário, para que a empresa ENCERRAR CONTRATO possa utilizá-los exclussivament no processo de encerramento do contrato junto a prestadora de serviço. Declaro estar ciente de que as informações fornecidas são verdadeiras e que compreendo as etapas necessaria para conclusão do encerramento', textAlign: TextAlign.justify,),
                          Row(children: [
                            Checkbox(value: agree.value, onChanged: (value) => agree.value = !agree.value),
                            Text('Li e aceito.')
                          ],),
                          Text('Clique para assinar.'),
                          ElevatedButton(
                            onPressed: agree.value?controller.register: null,
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(agree.value?Color.fromRGBO(255, 131, 33, 1.0):Colors.grey),
                              shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                            ), child: Text('ENVIAR'),)
                        ],
                      ), false.obs),
                )),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(Color.fromRGBO(255, 131, 33, 1.0)),
                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                ), child: Text('ENVIAR INFORMAÇÕES'),
              ),
              SizedBox(height: 100,)

            ],
          );
        }))
    );
  }
}
