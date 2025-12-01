import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:encerrar_contrato/app/routes/app_pages.dart';
import 'package:encerrar_contrato/app_theme.dart';
import 'package:get_storage/get_storage.dart';
import 'app/utils/interceptor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const env = String.fromEnvironment("ENV", defaultValue: "development");
  await GetStorage.init();
  await dotenv.load(fileName: ".env.$env");
  Get.put(DioProvider.createDio());
  runApp(const EC());
}

class EC extends StatelessWidget {
  const EC({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Encerrar Contrato',
      theme: AppTheme.light,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
