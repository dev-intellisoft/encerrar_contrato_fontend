import 'package:encerrar_contrato/app/models/service_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:encerrar_contrato/app/controllers/services_controller.dart';
import 'package:encerrar_contrato/app/widgets/logo.dart';
import 'package:encerrar_contrato/app/widgets/drawer.dart';

class ServiceForm extends GetView<ServicesController> {
  ServiceForm({super.key});

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
        backgroundColor: Color(0xFF0099FF),
        actions: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: Icon(Icons.person_3_rounded),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            if (controller.service.value.id == null)
              Text('Criar Serviço')
            else
              Text('Editar Serviço'),
            TextFormField(
              controller: TextEditingController(
                text: controller.service.value.name,
              ),
              onChanged: (value) =>
                  controller.service.update((s) => s!.name = value),
              decoration: InputDecoration(
                labelText: 'Nome',
                hintText: 'Digite o nome do serviço',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: TextEditingController(
                text: controller.service.value.description,
              ),
              onChanged: (value) =>
                  controller.service.update((s) => s!.description = value),
              decoration: InputDecoration(
                labelText: 'Descrição',
                hintText: 'Digite a descrição do serviço',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: TextEditingController(
                text: controller.service.value.price.toString(),
              ),
              onChanged: (value) => controller.service.update(
                (s) => s!.price = int.tryParse(value),
              ),
              decoration: InputDecoration(
                labelText: 'Preço',
                hintText: 'Digite o preço do serviço',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField(
              value: controller.service.value.type,
              decoration: InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              items: [
                DropdownMenuItem(
                  value: 'transfer',
                  child: Text('Transferência'),
                ),
                DropdownMenuItem(value: 'close', child: Text('Encerramento')),
              ],
              onChanged: (value) =>
                  controller.service.update((s) => s!.type = value),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: controller.save,
                  child: Text('Salvar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    controller.service.value = Service();
                    Get.back();
                  },
                  child: Text('Cancelar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
