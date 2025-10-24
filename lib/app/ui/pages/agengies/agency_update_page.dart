import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/agency_controller.dart';
import '../../../models/agency_model.dart';
import '../../../widgets/drawer.dart';
import '../../../widgets/logo.dart';

class AgencyUpdatePage extends GetView<AgencyController> {
  final Agency agency;

  AgencyUpdatePage({required this.agency, super.key});

  final nameCtrl = TextEditingController();
  final loginCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    nameCtrl.text = agency.name;
    loginCtrl.text = agency.login;
    passCtrl.text = agency.password;

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
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: loginCtrl, decoration: const InputDecoration(labelText: 'Login')),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updated = Agency(
                  id: agency.id,
                  name: nameCtrl.text,
                  image: '',
                  login: loginCtrl.text,
                  password: passCtrl.text,
                );
                await controller.updateAgency(agency.id!, updated);
                Get.back();
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
