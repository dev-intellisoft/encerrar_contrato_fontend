// import 'package:encerrar_contrato/app/widgets/logo_imobiliaria.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// import '../../../controllers/solicitation_controller.dart';
// import '../../../routes/app_pages.dart';
// import '../../../widgets/logo.dart';

// class SolicitationPage extends GetView<SolicitationController> {
//   const SolicitationPage({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//     return Scaffold(
//       appBar: AppBar(
//         title: Logo(),
//         backgroundColor: Color.fromRGBO(255, 131, 33, 1.0),
//         actions: [
//           IconButton(
//             onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
//             icon: Icon(Icons.person_3_rounded),
//           ),
//         ],
//       ),
//       endDrawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(color: Colors.blue),
//               child: Text('Drawer Header'),
//             ),
//             ListTile(
//               title: Text('Adicionar Imobiliária'),
//               onTap: () {
//                 Get.back();
//               },
//             ),
//             ListTile(
//               title: Text('Item 2'),
//               onTap: () {
//                 Get.back();
//               },
//             ),

//             ListTile(
//               title: Text('Logout'),
//               onTap: () => Get.offAllNamed(Routes.LOGIN),
//             ),
//           ],
//         ),
//       ),
//       body: Center(
//         child: Obx(
//           () => ListView(
//             children: [
//               Row(children: [LogoImobiliaria()]),
//               Text('Preencha os campos solicitados:'),

//               Container(
//                 margin: EdgeInsets.all(10),
//                 child: TextFormField(
//                   onChanged: (text) =>
//                       controller.solicitation.value.customer!.name = text,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(25),
//                       borderSide: BorderSide(color: Colors.black, width: 1),
//                     ),
//                     hintText: 'Digite seu nome completo',
//                     labelText: 'Nome completo',
//                   ),
//                 ),
//               ),

//               Container(
//                 margin: EdgeInsets.all(10),
//                 child: TextFormField(
//                   inputFormatters: [
//                     MaskTextInputFormatter(
//                       mask: '###.###.###-##',
//                       filter: {"#": RegExp(r'[0-9]')}, // only digits allowed
//                     ),
//                   ],
//                   onChanged: (text) =>
//                       controller.solicitation.value.customer!.cpf = text,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(25),
//                       borderSide: BorderSide(color: Colors.black, width: 1),
//                     ),
//                     labelText: 'CPF',
//                   ),
//                 ),
//               ),

//               Container(
//                 margin: EdgeInsets.all(10),
//                 child: TextFormField(
//                   inputFormatters: [
//                     MaskTextInputFormatter(
//                       mask: '##/##/####',
//                       filter: {"#": RegExp(r'[0-9]')}, // only digits allowed
//                     ),
//                   ],
//                   onChanged: (text) =>
//                       controller.solicitation.value.customer!.birthDate = text,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(25),
//                       borderSide: BorderSide(color: Colors.black, width: 1),
//                     ),
//                     labelText: 'Data de nascimento',
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.all(10),
//                 child: TextFormField(
//                   inputFormatters: [
//                     FilteringTextInputFormatter.deny(
//                       RegExp(r'[^a-zA-Z0-9@.]+'),
//                     ),
//                   ],

//                   onChanged: (text) =>
//                       controller.solicitation.value.customer!.email = text,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(25),
//                       borderSide: BorderSide(color: Colors.black, width: 1),
//                     ),
//                     labelText: 'Email',
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.all(10),
//                 child: TextFormField(
//                   inputFormatters: [
//                     MaskTextInputFormatter(
//                       mask: '(##) #####-####',
//                       filter: {"#": RegExp(r'[0-9]')}, // only digits allowed
//                     ),
//                   ],
//                   onChanged: (text) =>
//                       controller.solicitation.value.customer!.phone = text,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(25),
//                       borderSide: BorderSide(color: Colors.black, width: 1),
//                     ),
//                     labelText: 'Telefone(Whatsapp)',
//                   ),
//                 ),
//               ),

//               Text('Endereço:'),
//               Container(
//                 margin: EdgeInsets.all(10),
//                 child: TextFormField(
//                   inputFormatters: [
//                     MaskTextInputFormatter(
//                       mask: '##.###-###',
//                       filter: {"#": RegExp(r'[0-9]')}, // only digits allowed
//                     ),
//                   ],
//                   onChanged: controller.setCep,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(25),
//                       borderSide: BorderSide(color: Colors.black, width: 1),
//                     ),
//                     labelText: 'CEP',
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.all(10),
//                 child: TextFormField(
//                   controller: TextEditingController(
//                     text: controller.solicitation.value.address?.street,
//                   ),
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(25),
//                       borderSide: BorderSide(color: Colors.black, width: 1),
//                     ),
//                     labelText: 'Rua',
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.all(10),
//                 child: TextFormField(
//                   controller: TextEditingController(
//                     text: controller.solicitation.value.address?.neighborhood,
//                   ),
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(25),
//                       borderSide: BorderSide(color: Colors.black, width: 1),
//                     ),
//                     labelText: 'Bairro',
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.all(10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                       width: 150,
//                       child: TextFormField(
//                         onChanged: (text) => controller.solicitation.update(
//                           (s) => s!.address!.number = text,
//                         ),
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(25),
//                             borderSide: BorderSide(
//                               color: Colors.black,
//                               width: 1,
//                             ),
//                           ),
//                           labelText: 'Número',
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 150,
//                       child: TextFormField(
//                         controller: TextEditingController(
//                           text: controller.solicitation.value.address?.state,
//                         ),
//                         onChanged: (text) => controller.solicitation.update(
//                           (s) => s!.address!.state = text,
//                         ),
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(25),
//                             borderSide: BorderSide(
//                               color: Colors.black,
//                               width: 1,
//                             ),
//                           ),
//                           labelText: 'UF',
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Text('Serviço a encerrar:'),
//               Container(
//                 margin: EdgeInsets.all(10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Row(
//                     //   children: [
//                     //     Checkbox(
//                     //       value: controller.solicitation.value.water,
//                     //       onChanged: (value) => controller.solicitation.update(
//                     //         (s) => s!.water = !s.water,
//                     //       ),
//                     //     ),
//                     //     Text('Agua'),
//                     //   ],
//                     // ),
//                     Container(
//                       width: 300,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 5,
//                       ),
//                       child: TextFormField(
//                         onChanged: (text) => controller.solicitation.update(
//                           (s) => s!.waterCarrier = text,
//                         ),
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(25),
//                             borderSide: BorderSide(
//                               color: Colors.black,
//                               width: 1,
//                             ),
//                           ),
//                           labelText: 'Informa a empresa prestadora do serviço',
//                         ),
//                       ),
//                     ),

//                     // Row(
//                     //   children: [
//                     //     Checkbox(
//                     //       value: controller.solicitation.value.power,
//                     //       onChanged: (value) => controller.solicitation.update(
//                     //         (s) => s!.power = !s.power,
//                     //       ),
//                     //     ),
//                     //     Text('Energia'),
//                     //   ],
//                     // ),
//                     Container(
//                       width: 300,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 5,
//                       ),
//                       child: TextFormField(
//                         onChanged: (text) => controller.solicitation.update(
//                           (s) => s!.powerCarrier = text,
//                         ),
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(25),
//                             borderSide: BorderSide(
//                               color: Colors.black,
//                               width: 1,
//                             ),
//                           ),
//                           labelText: 'Informa a empresa prestadora do serviço',
//                         ),
//                       ),
//                     ),

//                     // Row(
//                     //   children: [
//                     //     Checkbox(
//                     //       value: controller.solicitation.value.gas,
//                     //       onChanged: (value) => controller.solicitation.update(
//                     //         (s) => s!.gas = !s.gas,
//                     //       ),
//                     //     ),
//                     //     Text('Gas'),
//                     //   ],
//                     // ),
//                     Container(
//                       width: 300,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 5,
//                       ),
//                       child: TextFormField(
//                         onChanged: (text) => controller.solicitation.update(
//                           (s) => s!.gasCarrier = text,
//                         ),
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(25),
//                             borderSide: BorderSide(
//                               color: Colors.black,
//                               width: 1,
//                             ),
//                           ),
//                           labelText: 'Informa a empresa prestadora do serviço',
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               ElevatedButton(
//                 onPressed: () => Get.dialog(
//                   AlertDialog(
//                     // title: Text('Termo de Consentimento.', textAlign: TextAlign.center,),
//                     content: ObxValue(
//                       (agree) => Column(
//                         children: [
//                           Text(
//                             'Termo de Consentimento.',
//                             textAlign: TextAlign.center,
//                           ),
//                           Text(
//                             'Autorizo o envio dos meus dados pessoais, conforme informado neste formulário, para que a empresa ENCERRAR CONTRATO possa utilizá-los exclussivament no processo de encerramento do contrato junto a prestadora de serviço. Declaro estar ciente de que as informações fornecidas são verdadeiras e que compreendo as etapas necessaria para conclusão do encerramento',
//                             textAlign: TextAlign.justify,
//                           ),
//                           Row(
//                             children: [
//                               Checkbox(
//                                 value: agree.value,
//                                 onChanged: (value) =>
//                                     agree.value = !agree.value,
//                               ),
//                               Text('Li e aceito.'),
//                             ],
//                           ),
//                           Text('Clique para assinar.'),
//                           ElevatedButton(
//                             onPressed: agree.value
//                                 ? controller.createSolicitation
//                                 : null,
//                             style: ButtonStyle(
//                               backgroundColor: WidgetStatePropertyAll<Color>(
//                                 agree.value
//                                     ? Color.fromRGBO(255, 131, 33, 1.0)
//                                     : Colors.grey,
//                               ),
//                               shape:
//                                   WidgetStatePropertyAll<
//                                     RoundedRectangleBorder
//                                   >(
//                                     RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(20),
//                                       side: BorderSide(
//                                         color: Colors.black,
//                                         width: 1,
//                                       ),
//                                     ),
//                                   ),
//                               padding:
//                                   WidgetStatePropertyAll<EdgeInsetsGeometry>(
//                                     EdgeInsets.symmetric(
//                                       vertical: 15,
//                                       horizontal: 20,
//                                     ),
//                                   ),
//                             ),
//                             child: Text('ENVIAR'),
//                           ),
//                         ],
//                       ),
//                       false.obs,
//                     ),
//                   ),
//                 ),
//                 style: ButtonStyle(
//                   backgroundColor: WidgetStatePropertyAll<Color>(
//                     Color.fromRGBO(255, 131, 33, 1.0),
//                   ),
//                   shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       side: BorderSide(color: Colors.black, width: 1),
//                     ),
//                   ),
//                   padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
//                     EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                   ),
//                 ),
//                 child: Text('ENVIAR INFORMAÇÕES'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
