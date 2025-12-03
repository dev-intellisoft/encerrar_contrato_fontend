import 'package:encerrar_contrato/app/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../widgets/agency_logo.dart';

class CloseForm extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => controller.getServices("close"),
    );
    return Obx(
      () => Expanded(
        child: Container(
          margin: EdgeInsets.all(10),
          child: ListView(
            children: [
              Row(
                children: [AgencyLogo(imagePath: controller.agencyLogo.value!)],
              ),
              SizedBox(height: 20),
              Text('Preencha os campos solicitados:'),

              SizedBox(height: 10),

              TextFormField(
                onChanged: (text) =>
                    controller.solicitation.value.customer!.name = text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  hintText: 'Digite seu nome completo',
                  labelText: 'Nome completo',
                ),
              ),

              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [
                        MaskTextInputFormatter(
                          mask: '###.###.###-##',
                          filter: {
                            "#": RegExp(r'[0-9]'),
                          }, // only digits allowed
                        ),
                      ],
                      onChanged: (text) =>
                          controller.solicitation.value.customer!.cpf = text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        labelText: 'CPF',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [
                        MaskTextInputFormatter(
                          mask: '##/##/####',
                          filter: {
                            "#": RegExp(r'[0-9]'),
                          }, // only digits allowed
                        ),
                      ],
                      onChanged: (text) =>
                          controller.solicitation.value.customer!.birthDate =
                              text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        labelText: 'Data de nascimento',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                          RegExp(r'[^a-zA-Z0-9@.]+'),
                        ),
                      ],

                      onChanged: (text) =>
                          controller.solicitation.value.customer!.email = text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [
                        MaskTextInputFormatter(
                          mask: '(##) #####-####',
                          filter: {
                            "#": RegExp(r'[0-9]'),
                          }, // only digits allowed
                        ),
                      ],
                      onChanged: (text) =>
                          controller.solicitation.value.customer!.phone = text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        labelText: 'Telefone(Whatsapp)',
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Text('Endereço:'),
              SizedBox(height: 10),
              TextFormField(
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: '##.###-###',
                    filter: {"#": RegExp(r'[0-9]')}, // only digits allowed
                  ),
                ],
                onChanged: controller.setCep,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  labelText: 'CEP',
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: TextEditingController(
                        text: controller.solicitation.value.address?.street,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        labelText: 'Rua',
                      ),
                    ),
                  ),

                  SizedBox(width: 10),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: 100,
                    child: TextFormField(
                      onChanged: (text) => controller.solicitation.update(
                        (s) => s!.address!.number = text,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        labelText: 'Número',
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: TextEditingController(
                  text: controller.solicitation.value.address?.neighborhood,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  labelText: 'Bairro',
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: TextEditingController(
                        text: controller.solicitation.value.address!.city,
                      ),
                      onChanged: (text) => controller.solicitation.update(
                        (s) => s!.address!.city = text,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        labelText: 'Cidade',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width: 100,
                    child: TextFormField(
                      controller: TextEditingController(
                        text: controller.solicitation.value.address?.state,
                      ),
                      onChanged: (text) => controller.solicitation.update(
                        (s) => s!.address!.state = text,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        labelText: 'UF',
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Text('Serviço a encerrar:'),

              Container(
                margin: EdgeInsets.all(10),
                child: ListView.builder(
                  shrinkWrap:
                      true, // important for ListView inside other widgets
                  physics:
                      NeverScrollableScrollPhysics(), // prevents scroll conflict
                  itemCount: controller.services.length,
                  itemBuilder: (context, index) {
                    final service = controller.services[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: controller.services[index].selected,
                              onChanged: (value) => controller.services[index] =
                                  service.copyWith(selected: value!),
                            ),
                            Text(service.name!),
                          ],
                        ),

                        Container(
                          width: 300,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            onChanged: (text) => controller.services[index] =
                                service.copyWith(companyName: text),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              labelText:
                                  'Informa a empresa prestadora do serviço',
                            ),
                          ),
                        ),

                        SizedBox(height: 12),
                      ],
                    );
                  },
                ),
              ),

              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: '),
                    Text("R\$ ${_priceTotal().toString()}"),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => Get.dialog(
                  AlertDialog(
                    title: Text(
                      'Termo de Consentimento.',
                      textAlign: TextAlign.center,
                    ),
                    content: ObxValue(
                      (agree) => Column(
                        children: [
                          Text(
                            'Termo de Consentimento.',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Autorizo o envio dos meus dados pessoais, conforme informado neste formulário, para que a empresa ENCERRAR CONTRATO possa utilizá-los exclussivament no processo de encerramento do contrato junto a prestadora de serviço. Declaro estar ciente de que as informações fornecidas são verdadeiras e que compreendo as etapas necessaria para conclusão do encerramento',
                            textAlign: TextAlign.justify,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: agree.value,
                                onChanged: (value) =>
                                    agree.value = !agree.value,
                              ),
                              Text('Li e aceito.'),
                            ],
                          ),
                          Text('Clique para assinar.'),
                          ElevatedButton(
                            onPressed: agree.value ? controller.register : null,
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                agree.value
                                    ? Color.fromRGBO(255, 131, 33, 1.0)
                                    : Colors.grey,
                              ),
                              shape:
                                  WidgetStatePropertyAll<
                                    RoundedRectangleBorder
                                  >(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                              padding:
                                  WidgetStatePropertyAll<EdgeInsetsGeometry>(
                                    EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 20,
                                    ),
                                  ),
                            ),
                            child: Text('ENVIAR'),
                          ),
                        ],
                      ),
                      false.obs,
                    ),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                    Color.fromRGBO(255, 131, 33, 1.0),
                  ),
                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
                child: Text('ENVIAR INFORMAÇÕES'),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  double _priceTotal() {
    double total = 0.0;
    for (var service in controller.services) {
      if (service.selected) {
        total += service.price!;
      }
    }
    return total;
  }
}
