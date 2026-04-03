import 'dart:ui';

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
      scrollBehavior: const AppScrollBehavior(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.unknown,
  };

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 700;

    return Scrollbar(
      controller: details.controller,
      thumbVisibility: true,
      trackVisibility: false,
      interactive: true,
      thickness: isCompact ? 2 : 3,
      radius: const Radius.circular(999),
      child: child,
    );
  }
}
