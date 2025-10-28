import 'package:encerrar_contrato/app/widgets/agencya.dart';
import 'package:encerrar_contrato/app/widgets/agencyb.dart';
import 'package:encerrar_contrato/app/widgets/logo.dart';
import 'package:encerrar_contrato/app/widgets/logo_imobiliaria.dart';
import 'package:encerrar_contrato/app/widgets/search_icon.dart';
import 'package:get/get.dart';
import 'package:encerrar_contrato/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:encerrar_contrato/app/controllers/home_controller.dart';
import '../../../models/solicitation_model.dart';
import '../../../widgets/done.dart';
import '../../../widgets/drawer.dart';
import '../../../widgets/pending.dart';
import '../../../widgets/processing.dart';
import '../../../widgets/solicitation_tile.dart';

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
      endDrawer: DrawerWidget(),
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
                // onPressed: () => Get.toNamed(Routes.SOLICITATION),
                onPressed: () => Get.dialog(AlertDialog(
                  title: Text('Detalhes do contrato'),
                  content: Container(
                    height: 250,
                    width:400,
                    child: Obx(() {
                      if(controller.loading.value) {
                        return Center(child: CircularProgressIndicator(),);
                      }
                      return Column(
                        children: [
                          Text('Enviar link por e-mail'),
                          TextField(
                            onChanged: (value) => controller.name.value = value,
                            decoration: InputDecoration(
                              labelText: 'Nome',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.black, width: 1),
                              ),
                            ),
                          ),
                          TextFormField(
                            onChanged: (value) => controller.email.value = value,
                            decoration: InputDecoration(
                              labelText: 'E-mail',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.black, width: 1),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          ElevatedButton(
                            onPressed: controller.sendEmail,
                            child: Text('Enviar'),
                          ),
                        ],
                      );
                    })
                  ))),
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
                  ).map((s) => SolicitationTile(solicitation: s, onTap: (solicitation) {
                    Get.dialog(AlertDialog(
                      title: Text('Detalhes do contrato'),
                      content: Container(
                        height: 300,
                        child: Column(
                          children: [
                            Text('${solicitation.customer!.name}'),
                            Text('${solicitation.customer!.email}'),
                            Text('${solicitation.customer!.phone}'),
                            Text('${solicitation.customer!.cpf}'),
                            Text('${solicitation.address!.street}, ${solicitation.address!.number} ${solicitation.address!.complement}'),
                            Text('${solicitation.address!.neighborhood}, ${solicitation.address!.city}, ${solicitation.address!.state}'),
                            if(solicitation.status == SolicitationStatus.done)
                              Row(
                                children: [
                                  Text('Encerrado'),
                                  Done(),
                                ],
                              )
                            else if(solicitation.status == SolicitationStatus.processing)
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
                  },)).toList(),
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
