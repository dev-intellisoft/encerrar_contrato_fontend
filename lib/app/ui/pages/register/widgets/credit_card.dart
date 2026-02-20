import 'package:encerrar_contrato/app/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreditCard extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            'Dados do titular do cartão',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              onChanged: (text) => controller.creditCard.value.number = text,
              decoration: InputDecoration(
                label: Text(
                  'Número do cartão',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              onChanged: (text) =>
                  controller.creditCard.value.holderName = text,
              controller: TextEditingController(
                text: controller.creditCard.value.holderName,
              ),
              decoration: InputDecoration(
                label: Text(
                  'Nome impresso no cartão',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    onChanged: (text) =>
                        controller.creditCard.value.expiryMonth = text,
                    decoration: InputDecoration(
                      label: Text('Mês', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    onChanged: (text) =>
                        controller.creditCard.value.expiryYear = text,
                    decoration: InputDecoration(
                      label: Text('Ano', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    onChanged: (text) => controller.creditCard.value.ccv = text,
                    decoration: InputDecoration(
                      label: Text('CVV', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              onChanged: (text) =>
                  controller.creditCardHolderInfo.value.name = text,
              controller: TextEditingController(
                text: controller.creditCardHolderInfo.value.name,
              ),
              decoration: InputDecoration(
                label: Text(
                  'Nome do titular',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    onChanged: (text) =>
                        controller.creditCardHolderInfo.value.cpfCnpj = text,
                    controller: TextEditingController(
                      text: controller.creditCardHolderInfo.value.cpfCnpj,
                    ),
                    decoration: InputDecoration(
                      label: Text('CPF', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    onChanged: (text) =>
                        controller.creditCardHolderInfo.value.phone = text,
                    controller: TextEditingController(
                      text: controller.creditCardHolderInfo.value.phone,
                    ),
                    decoration: InputDecoration(
                      label: Text(
                        'Telefone',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              onChanged: (text) =>
                  controller.creditCardHolderInfo.value.email = text,
              controller: TextEditingController(
                text: controller.creditCardHolderInfo.value.email,
              ),
              decoration: InputDecoration(
                label: Text('E-mail', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    onChanged: (text) =>
                        controller.creditCardHolderInfo.value.postalCode = text,
                    controller: TextEditingController(
                      text: controller.creditCardHolderInfo.value.postalCode,
                    ),
                    decoration: InputDecoration(
                      label: Text('CEP', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    onChanged: (text) =>
                        controller.creditCardHolderInfo.value.addressNumber =
                            text,
                    controller: TextEditingController(
                      text: controller.creditCardHolderInfo.value.addressNumber,
                    ),
                    decoration: InputDecoration(
                      label: Text(
                        'Número',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: controller.processCreditCardPayment,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF0099FF),
                // color:  Color.fromRGBO(255, 131, 33, 1.0)
              ),
              child: Center(
                child: Text('Pagar', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
