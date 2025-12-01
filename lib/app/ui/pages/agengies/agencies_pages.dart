import 'package:encerrar_contrato/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../../../controllers/agency_controller.dart';
import '../../../widgets/drawer.dart';
import '../../../widgets/logo.dart';
// import 'agency_create_page.dart';
// import 'agency_view_page.dart';

class AgencyPage extends GetView<AgencyController> {
  const AgencyPage({super.key});
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    controller.fetchAgencies();

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.AGENCY_FORM),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.agencies.isEmpty) {
          return const Center(child: Text('No agencies found.'));
        }
        return ListView.builder(
          itemCount: controller.agencies.length,
          itemBuilder: (context, index) {
            final agency = controller.agencies[index];
            return ListTile(
              leading: Container(
                height: 30,
                width: 30,
                child: Image.network(
                  '${dotenv.env['API_URL']!}${agency.image!}',
                  fit: BoxFit.cover,

                  // Placeholder while loading
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },

                  // Placeholder on error (broken link, offline, 404)
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
              title: Text(agency.name!),
              subtitle: Text(agency.login!),
              onTap: () {
                controller.agency.value = agency;
                Get.toNamed(Routes.AGENCY_FORM);
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => Get.dialog(
                  AlertDialog(
                    title: Text('Warning'),
                    // icon: Icon(Icons.warning),
                    content: Text(
                      'Tem certeza que deseja remover a imobiliária?',
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Get.back(),
                        child: Text('Não'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white, // text/icon color
                        ),
                        onPressed: () => controller.deleteAgency(agency.id!),
                        child: Text('Sim'),
                      ),
                    ],
                  ),
                ),
                // onPressed: () async {
                //   await controller.deleteAgency(agency.id!);
                // },
              ),
            );
          },
        );
      }),
    );
  }
}
