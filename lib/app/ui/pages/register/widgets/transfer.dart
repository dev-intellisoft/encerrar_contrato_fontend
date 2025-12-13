import 'package:encerrar_contrato/app/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../widgets/agency_logo.dart';

class TransferForm extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getServices('transfer');
    });
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
              Text('Dados do atual titular:'),

              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
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
              ),
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
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
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
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
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
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
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
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        onChanged: (text) => controller.solicitation.update(
                          (s) => s!.address!.number = text,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          labelText: 'Número',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
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
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          labelText: 'UF',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              Text('Dados do novo titular'),

              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: TextField(
                  controller: TextEditingController(
                    text: controller.documents.value.documentPhotoName ?? '',
                  ),
                  onTap: controller.pickDocumentPhoto,
                  decoration: const InputDecoration(
                    labelText: 'Foto do documento',
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  controller: TextEditingController(
                    text:
                        controller.documents.value.photoWithDocumentName ?? '',
                  ),
                  onTap: controller.pickPhotoWithDocument,
                  decoration: const InputDecoration(
                    labelText: 'Foto com documento',
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  controller: TextEditingController(
                    text: controller.documents.value.lastInvoiceName ?? '',
                  ),
                  onTap: controller.pickLastInvoice,
                  decoration: const InputDecoration(
                    labelText: 'Última fatura do serviço',
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  controller: TextEditingController(
                    text: controller.documents.value.contractName ?? '',
                  ),
                  onTap: controller.pickContract,
                  decoration: const InputDecoration(
                    labelText: 'Inserir contrato (locação/ compra e venda)',
                  ),
                  // onFilePicked: (file) => controller.contract.value = file,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(label: Text("Telefone")),
                ),
              ),

              SizedBox(height: 20),

              Text('Serviço a encerrar:'),

              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
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
                          padding: EdgeInsets.symmetric(
                            // horizontal: 10,
                            vertical: 5,
                          ),
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
                            onPressed: agree.value ? controller.transfer : null,
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
