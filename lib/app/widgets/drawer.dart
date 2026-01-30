import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../routes/app_pages.dart';
import '../models/agency_model.dart';

Future<Agency> whoAmI() async {
  Agency agency = Agency();
  var user = await GetStorage().read('user');
  if (user != null) {
    agency = Agency.fromJson(user);
  }

  return agency;
}

class DrawerWidget extends GetView {
  const DrawerWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Agency>(
        future: whoAmI(),
        builder: (context, AsyncSnapshot<Agency> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text('Drawer Header'),
                ),
                if (snapshot.data!.agency == "encerrar")
                  ListTile(
                    title: Text('Imobilárias'),
                    onTap: () {
                      Get.offNamed(Routes.AGENCIES);
                      Get.back();
                    },
                  ),
                if (snapshot.data!.agency == "encerrar")
                  ListTile(
                    title: Text('Serviços'),
                    onTap: () {
                      Get.offNamed(Routes.SERVICES);
                      Get.back();
                    },
                  ),
                ListTile(
                  title: Text('Logout'),
                  onTap: () {
                    GetStorage().remove('token');
                    Get.offAllNamed(Routes.LOGIN);
                  },
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
