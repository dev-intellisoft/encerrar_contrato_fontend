import 'package:encerrar_contrato/app/controllers/agency_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/agency_model.dart';
import '../../../widgets/drawer.dart';
import '../../../widgets/logo.dart';

class AgencyViewPage extends GetView<AgencyController> {
  final Agency agency;
  const AgencyViewPage({required this.agency, super.key});


  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Login: ${agency.login}'),
            const SizedBox(height: 10),
            Text('Password: ${agency.password}'),
          ],
        ),
      ),
    );
  }
}
