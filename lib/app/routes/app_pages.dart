import 'package:get/get.dart';
import '../bindings/customer_binding.dart';
import '../bindings/dashboard_controller.dart';
import '../bindings/solicitation_binding.dart';
import '../ui/pages/dashboard/dashboard_page.dart';
import '../ui/pages/login/login_page.dart';
import '../bindings/login_binding.dart';
import '../ui/pages/home/home_page.dart';
import '../bindings/home_binding.dart';
import '../ui/pages/register/register_page.dart';
import '../bindings/register_binding.dart';
import '../ui/pages/solicitation/solicitation_page.dart';

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
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.SOLICITATION,
      page: () => const SolicitationPage(),
      bindings: [CustomerBinding(), SolicitationBinding()],
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
  ];
}
