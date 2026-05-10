import 'package:edutech/app/modules/home/home_binding.dart';
import 'package:get/get.dart';
import 'app_routes.dart';
import '../modules/login/login_view.dart';
import '../modules/login/login_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/writing_practice/writing_practice_view.dart';
import '../modules/writing_practice/writing_practice_binding.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.WRITING,
      page: () => const WritingPracticeView(),
      binding: WritingPracticeBinding(),
    ),
  ];

}