import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../models/solicitation_model.dart';
import '../../../widgets/drawer.dart';
import '../../../widgets/logo.dart';
import '../../../widgets/solicitation_tile.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.getSolicitations());
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: DrawerWidget(),
        appBar: AppBar(
          leading: null,
          title:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Logo(),
              SizedBox(
                width:  200,
                height: 35,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Buscar',
                    hintText: 'Digite para buscar',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              )
            ]
          ),
          backgroundColor: Color.fromRGBO(255, 131, 33, 1.0),
          actions: [
            IconButton(
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
              icon: Icon(Icons.person_3_rounded),
            ),
          ],
        ),
        body:Row(
          children: [
            Container(
              width: 500,
              child: Column(
                children: [
                  Text('Casos para atender:'),
                  Expanded(
                    child: Obx(() => controller.loading.isTrue ? Center(child: CircularProgressIndicator()) : controller.solicitations.isEmpty ? Center(child: Text('Nenhuma solicitação encontrada')) : ListView(
                      children: controller.solicitations.map((s) => SolicitationTile(
                                  solicitation: s,
                          onTap: (v) => controller.solicitation.value = v
                      )).toList(),
                    )),
                  )
                ],
              ),
            ),
            Container(
              width: 400,
              child: Column(
                children: [
                  Text('Casa a ser atendido'),
                  Obx(() => controller.solicitation.value!.id! > BigInt.zero ? Expanded(
                    child: Column(
                        children:[
                          Text('Cliente'),
                          SizedBox(height: 10,),
                          TextFormField(
                            initialValue: controller.solicitation.value?.customer!.name,
                            decoration: InputDecoration(
                              labelText: 'Nome',
                              hintText: 'Digite o nome',
                            ),
                            readOnly: true,
                          ),
                          SizedBox(height: 10,),
                          TextFormField(initialValue: controller.solicitation.value?.customer!.cpf, decoration: InputDecoration(labelText: 'CPF/CNPJ', hintText: 'Digite o CPF/CNPJ'), readOnly: true,),
                          SizedBox(height: 10,),
                          TextFormField(initialValue: controller.solicitation.value?.customer!.email, decoration: InputDecoration(labelText: 'Email', hintText: 'Digite o email'), readOnly: true,),
                          SizedBox(height: 10,),
                          TextFormField(initialValue: controller.solicitation.value?.customer!.phone, decoration: InputDecoration(labelText: 'Telefone', hintText: 'Digite o telefone'), readOnly: true,),
                          SizedBox(height: 10,),
                          Text('Endereço'),
                          SizedBox(height: 10,),
                          Row(children: [
                            Expanded(child: TextFormField(initialValue: controller.solicitation.value?.address!.street, decoration: InputDecoration(labelText: 'Rua', hintText: 'Digite a rua'), readOnly: true,),),
                            Container(
                              width: 100,
                              margin: EdgeInsets.only(left: 10),
                              child: TextFormField(initialValue: controller.solicitation.value?.address!.number, decoration: InputDecoration(labelText: 'Número', hintText: 'Digite o número'), readOnly: true,),
                            )
                          ]),
                          SizedBox(height: 10,),
                          TextFormField(initialValue: controller.solicitation.value?.address!.neighborhood, decoration: InputDecoration(labelText: 'Bairro', hintText: 'Digite o bairro'), readOnly: true,),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                             Expanded(child:  TextFormField(initialValue: controller.solicitation.value?.address!.city, decoration: InputDecoration(labelText: 'Cidade', hintText: 'Digite a cidade'), readOnly: true,),),
                             Container(
                               width: 100,
                               margin: EdgeInsets.only(left: 10),
                               child:  TextFormField(initialValue: controller.solicitation.value?.address!.state, decoration: InputDecoration(labelText: 'Estado', hintText: 'Digite o estado'), readOnly: true,),
                             )
                            ],
                          ),
                          SizedBox(height: 10,),
                          TextFormField(initialValue: controller.solicitation.value?.address!.zipCode, decoration: InputDecoration(labelText: 'CEP', hintText: 'Digite o cep'), readOnly: true,),
                          SizedBox(height: 10,),
                          if(controller.solicitation.value!.status == SolicitationStatus.pending)
                            ElevatedButton(onPressed: () => controller.startSolicitation(), child: Text('Iniciar atendimento'))
                          else if(controller.solicitation.value!.status == SolicitationStatus.processing)
                            ElevatedButton(onPressed: () => controller.endSolicitation(), child: Text('Concluir atendimento'), style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green)),),
                          SizedBox(height: 10,),
                          controller.solicitation.value!.status == SolicitationStatus.done ? Text('Concluido')
                              : controller.solicitation.value!.status == SolicitationStatus.processing ? Text('Em andamento')
                              : Text('Nao iniciado')
                        ]
                    ),
                  ):Center(child: Text('Nenhuma solicitação selecionada')))
                ],
              ),
            )
          ]
        )
    );
  }
}
