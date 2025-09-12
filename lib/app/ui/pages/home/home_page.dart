import 'dart:convert';

import 'package:encerrar_contrato/app/widgets/agencya.dart';
import 'package:encerrar_contrato/app/widgets/agencyb.dart';
import 'package:encerrar_contrato/app/widgets/logo.dart';
import 'package:encerrar_contrato/app/widgets/logo_imobiliaria.dart';
import 'package:encerrar_contrato/app/widgets/search_icon.dart';
import 'package:get/get.dart';
import 'package:encerrar_contrato/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:encerrar_contrato/app/controllers/home_controller.dart';
import 'package:encerrar_contrato/app/models/solicitation_model.dart';
import 'package:get_storage/get_storage.dart';

import '../../../widgets/done.dart';
import '../../../widgets/pending.dart';
import '../../../widgets/processing.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.load());
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title:  Logo(),
        backgroundColor: Color.fromRGBO(255, 131, 33, 1.0),
        actions: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: Icon(Icons.person_3_rounded),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Get.back();
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                Get.back();
              },
            ),

            ListTile(
              title: Text('Logout'),
              onTap: () {
                GetStorage().remove('token');
                Get.offAllNamed(Routes.LOGIN);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => Container( margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20), child: Row(
                  children:[
                    if(controller.agency.value == 'a')
                      AgencyALogo()
                    else if(controller.agency.value == 'b')
                      AgencyBLogo()
                    else
                      LogoImobiliaria()
                  ]
              ),)),
              Text(
                'Forneça as informações necessária para o encerramento do contrato.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromRGBO(61, 196, 250, 1.0)),
              ),
              Container( margin:EdgeInsets.symmetric(vertical: 5), child: ElevatedButton(
                onPressed: () => Get.toNamed(Routes.SOLICITATION),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(Color.fromRGBO(255, 131, 33, 1.0)),
                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 17, horizontal: 35)),
                ),
                child: Text('Cadastrar informações'),
              ),),
              SizedBox(height: 25,)
            ],
          ),

          Container(
            width: double.infinity,
            color: Color.fromRGBO(255, 131, 33, 1.0),
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Histórico de contratos', style: TextStyle(color: Colors.white), ),
                  ),
                  SizedBox(
                    height: 30,
                    width: 150,
                    child: TextFormField(
                      onChanged: (value) => controller.search.value = value,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(labelText: 'Procurar',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.lightBlue, width: 2),
                        // side: BorderSide(color: Colors.black, width: 1),
                      ),
                        prefixIcon: SearchIcon(),

                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              // height: 300,
              width: double.infinity,
              color: Color.fromRGBO(255, 131, 33, 1.0),
              child: Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),

                child: Obx(() => controller.loading.value?Center(child: CircularProgressIndicator(),):ListView(
                  children: controller.solicitations.isEmpty? [Center(child: Text('Nenhum solicitação!'),)]: controller.solicitations.where(
                          (s) => s.customer!.name!.toLowerCase().contains(controller.search.value.toLowerCase())
                  ).map((s) {
                    return GestureDetector(
                      onTap: () {
                        Get.dialog(AlertDialog(
                          title: Text('Detalhes do contrato'),
                          content: Container(
                            height: 300,
                            child: Column(
                              children: [
                                Text('${s.customer!.name}'),
                                Text('${s.customer!.email}'),
                                Text('${s.customer!.phone}'),
                                Text('${s.customer!.cpf}'),
                                Text('${s.address!.street}, ${s.address!.number} ${s.address!.complement}'),
                                Text('${s.address!.neighborhood}, ${s.address!.city}, ${s.address!.state}'),
                                if(s.status == SolicitationStatus.done)
                                  Row(
                                    children: [
                                      Text('Encerrado'),
                                      Done(),
                                    ],
                                  )
                                else if(s.status == SolicitationStatus.processing)
                                  Row(
                                    children: [
                                      Text('Em andamento'),
                                      Processing(),
                                    ],
                                  )
                                else
                                  Row(
                                    children: [
                                      Text('Pendente'),
                                      Pending(),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Color(0xFF138ED7),
                          border: Border.all(color: Color(0xFF171717), width: 1.5),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            s.status == SolicitationStatus.done ? Done() :  SolicitationStatus.processing == s.status?Processing():  Pending(),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${s.customer!.name}' , style: TextStyle(color: Colors.white),),
                                  Text(
                                    '${s.address!.street}, ${s.address!.number}, ${s.address!.state}',
                                    style: TextStyle(fontSize: 12, color: Colors.white,),
                                  ),
                                ],
                              )
                            ),
                            Row(
                              children: [
                                if(s.agency == 'a')
                                  AgencyALogo()
                                else if(s.agency == 'b')
                                  AgencyBLogo()
                              ]
                            )
                          ],
                        ),
                      )
                    );
                  }).toList(),
                ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
