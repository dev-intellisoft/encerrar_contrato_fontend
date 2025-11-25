import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:encerrar_contrato/app/controllers/services_controller.dart';
import 'package:encerrar_contrato/app/widgets/logo.dart';
import 'package:encerrar_contrato/app/widgets/drawer.dart';

class ServicesCreatePage extends GetView<ServicesController> {
  const ServicesCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
      body: Column(children: [Text('Criar Serviço')]),
    );
  }
}
