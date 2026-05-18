import 'package:get/get.dart';

import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/leaderboard/bindings/leaderboard_binding.dart';
import '../modules/leaderboard/views/leaderboard_view.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import 'app_routes.dart';
import '../modules/home/home_view.dart';
import '../modules/writing_practice/views/writing_practice_view.dart';
import '../modules/writing_practice/bindings/writing_practice_binding.dart';
import '../modules/writing_practice/views/writing_category_view.dart';
import '../modules/writing_practice/views/letter_selection_view.dart';
import '../modules/writing_practice/bindings/letter_selection_binding.dart';
import '../modules/writing_exam/views/writing_exam_view.dart';
import '../modules/writing_exam/views/writing_exam_category_view.dart';
import '../modules/writing_exam/bindings/writing_exam_binding.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.LEADERBOARD,
      page: () => const LeaderboardView(),
      binding: LeaderboardBinding(),
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
    GetPage(
      name: Routes.WRITING_CATEGORY,
      page: () => const WritingCategoryView(),
    ),
    GetPage(
      name: Routes.LETTER_SELECTION,
      page: () => const LetterSelectionView(),
      binding: LetterSelectionBinding(),
    ),
    GetPage(
      name: Routes.WRITING_EXAM,
      page: () => const WritingExamView(),
      binding: WritingExamBinding(),
    ),
    GetPage(
      name: Routes.WRITING_EXAM_CATEGORY,
      page: () => const WritingExamCategoryView(),
    ),
  ];
}
