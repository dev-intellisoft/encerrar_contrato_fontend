import 'package:encerrar_contrato/app/ui/pages/agengies/widgets/agency_form.dart';
import 'package:get/get.dart';
import '../bindings/agencies_binding.dart';
import '../bindings/customer_binding.dart';
import '../bindings/dashboard_controller.dart';
import '../bindings/solicitation_binding.dart';
import '../ui/pages/agengies/agencies_pages.dart';
import '../ui/pages/dashboard/dashboard_page.dart';
import '../ui/pages/login/login_page.dart';
import '../bindings/login_binding.dart';
import '../ui/pages/home/home_page.dart';
import '../bindings/home_binding.dart';
import '../ui/pages/register/register_page.dart';
import '../bindings/register_binding.dart';
import '../ui/pages/services/services_page.dart';
import '../bindings/services_binding.dart';
import '../ui/pages/services/widgets/service_form.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginPage(),
      binding: LoginBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () {
        String? agencyId = Get.parameters['agency_id']; // ?? debugAgencyId;
        // agencyId = '10160d72-3b5f-468a-bf02-ba954a20ffb9'
        return RegisterPage(agencyId: agencyId!);
      },
      binding: RegisterBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardPage(),
      bindings: [DashboardBinding(), CustomerBinding(), SolicitationBinding()],
    ),
    GetPage(
      name: Routes.AGENCIES,
      page: () => AgencyPage(),
      binding: AgenciesBinding(),
    ),
    GetPage(
      name: Routes.SERVICES,
      page: () => ServicesPage(),
      binding: ServicesBinding(),
    ),
    GetPage(
      name: Routes.SERVICE_FORM,
      page: () => ServiceForm(),
      binding: ServicesBinding(),
    ),
    GetPage(
      name: Routes.AGENCY_FORM,
      page: () => AgencyForm(),
      binding: AgenciesBinding(),
    ),
  ];
}
