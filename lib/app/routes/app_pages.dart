import 'package:get/get.dart';
import 'app_routes.dart';
import '../modules/login/login_view.dart';
import '../modules/login/login_binding.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
  ];
}