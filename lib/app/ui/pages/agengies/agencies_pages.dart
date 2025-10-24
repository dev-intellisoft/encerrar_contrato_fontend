import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/agency_controller.dart';
import '../../../widgets/drawer.dart';
import '../../../widgets/logo.dart';
import 'agency_create_page.dart';
import 'agency_view_page.dart';

class AgencyPage extends GetView<AgencyController> {

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    controller.fetchAgencies();

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AgencyCreatePage()),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        if (controller.agencies.isEmpty) return const Center(child: Text('No agencies found.'));
        return ListView.builder(
          itemCount: controller.agencies.length,
          itemBuilder: (context, index) {
            final agency = controller.agencies[index];
            return ListTile(
              title: Text(agency.name),
              subtitle: Text(agency.login),
              onTap: () => Get.to(() => AgencyViewPage(agency: agency)),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await controller.deleteAgency(agency.id!);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
