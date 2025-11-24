import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/agency_controller.dart';
import '../../../widgets/drawer.dart';
import '../../../widgets/logo.dart';

class AgencyCreatePage extends GetView<AgencyController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                onChanged: (text) => controller.agency.update((a) => a!.name = text),
                decoration: const InputDecoration(labelText: 'Name')),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                onChanged: (text) => controller.agency.update((a) => a!.login = text),
                decoration: const InputDecoration(labelText: 'Login')),),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                onChanged: (text) => controller.agency.update((a) => a!.password = text),
                decoration: const InputDecoration(labelText: 'Password')),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                onTap: controller.pickFile,
                decoration: const InputDecoration(labelText: 'Logo')),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.addAgency,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
