import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../controllers/services_controller.dart';
import '../../../widgets/logo.dart';
import '../../../widgets/drawer.dart';
import '../../../routes/app_pages.dart';

class ServicesPage extends GetView<ServicesController> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getServices();
    });
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
      body: Column(
        children: [
          Text('Serviços'),
          Obx(
            () => Expanded(
              child: ListView.builder(
                itemCount: controller.services.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    controller.service.value = controller.services[index];
                    Get.toNamed(Routes.SERVICE_FORM);
                  },
                  title: Text(controller.services[index].name!),
                  subtitle: Text(controller.services[index].description!),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () => Get.dialog(
                      AlertDialog(
                        title: Text('Warning'),
                        // icon: Icon(Icons.warning),
                        content: Text(
                          'Tem certeza que deseja remover o serviço?',
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
                            onPressed: () => controller.removeService(
                              controller.services[index].id!,
                            ),
                            child: Text('Sim'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.SERVICE_FORM),
        child: Icon(Icons.add),
      ),
    );
  }
}
