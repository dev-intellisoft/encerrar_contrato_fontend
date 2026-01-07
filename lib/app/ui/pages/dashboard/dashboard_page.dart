import 'package:encerrar_contrato/app/ui/pages/dashboard/widgets/document.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../models/solicitation_model.dart';
import '../../../widgets/drawer.dart';
import '../../../widgets/logo.dart';
import 'widgets/solicitation_tile.dart';
import 'widgets/address.dart';
import 'widgets/customer.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => controller.getSolicitations(),
    );
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: DrawerWidget(),
      appBar: AppBar(
        leading: null,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Logo(),
            SizedBox(
              width: 200,
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
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(255, 131, 33, 1.0),
        actions: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: Icon(Icons.person_3_rounded),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 500,
              child: Column(
                children: [
                  Text('Casos para atender:'),
                  Expanded(
                    child: Obx(
                      () => controller.loading.isTrue
                          ? Center(child: CircularProgressIndicator())
                          : controller.solicitations.isEmpty
                          ? Center(
                              child: Text('Nenhuma solicitação encontrada'),
                            )
                          : ListView(
                              children: controller.solicitations
                                  .map(
                                    (s) => SolicitationTile(
                                      solicitation: s,
                                      onTap: (v) =>
                                          controller.solicitation.value = v,
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color.fromARGB(255, 239, 244, 247),
                  // border: Border.all(color: Color(0xFF171717), width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Caso a ser atendido'),
                    Obx(
                      () =>
                          controller.solicitation.value!.id != null &&
                              controller.solicitation.value!.id! != ''
                          ? Column(
                              children: [
                                Customer(),

                                Address(),

                                Text(controller.solicitation.value!.service!),

                                if (controller.solicitation.value!.service ==
                                    'transfer')
                                  Document(),

                                for (var service
                                    in controller.solicitation.value!.services!)
                                  Text('Serviço: ' + service.name!),
                                SizedBox(height: 10),
                                if (controller.solicitation.value!.status ==
                                    SolicitationStatus.pending)
                                  ElevatedButton(
                                    onPressed: () =>
                                        controller.startSolicitation(),
                                    child: Text('Iniciar atendimento'),
                                  )
                                else if (controller
                                        .solicitation
                                        .value!
                                        .status ==
                                    SolicitationStatus.processing)
                                  ElevatedButton(
                                    onPressed: () =>
                                        controller.endSolicitation(),
                                    child: Text('Concluir atendimento'),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                        Colors.green,
                                      ),
                                    ),
                                  ),

                                SizedBox(height: 10),
                                controller.solicitation.value!.status ==
                                        SolicitationStatus.done
                                    ? Text('Concluido')
                                    : controller.solicitation.value!.status ==
                                          SolicitationStatus.processing
                                    ? Text('Em andamento')
                                    : Text('Nao iniciado'),
                              ],
                            )
                          : Expanded(
                              child: Center(
                                child: Text(
                                  'Selecione uma solicitação para ver os detalhes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
