import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../routes/app_pages.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: Text('Imobilárias'),
            onTap: () {
              Get.offNamed(Routes.AGENCIES);
              Get.back();
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
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
      ),
    );
  }
}