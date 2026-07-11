import 'package:get/get.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/leaderboard/bindings/leaderboard_binding.dart';
import '../modules/leaderboard/views/leaderboard_view.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import '../modules/raport/bindings/raport_binding.dart';
import '../modules/raport/views/raport_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/spelling_exam/bindings/spelling_exam_binding.dart';
import '../modules/spelling_exam/bindings/spelling_exam_menu_binding.dart';
import '../modules/spelling_exam/views/spelling_exam_category_view.dart';
import '../modules/spelling_exam/views/spelling_exam_view.dart';
import '../modules/spelling_exam/views/spelling_exam_menu_view.dart';
import '../modules/spelling_practice/bindings/spelling_practice_binding.dart';
import '../modules/spelling_practice/views/spelling_category_view.dart';
import '../modules/spelling_practice/views/spelling_practice_view.dart';
import '../modules/spelling_practice/views/spelling_letter_selection_view.dart';
import '../modules/spelling_practice/views/spelling_word_selection_view.dart';
import '../modules/writing_exam/bindings/writing_exam_binding.dart';
import '../modules/writing_exam/views/writing_exam_view.dart';
import '../modules/writing_practice/bindings/letter_selection_binding.dart';
import '../modules/writing_practice/bindings/writing_practice_binding.dart';
import '../modules/writing_practice/views/letter_selection_view.dart';
import '../modules/writing_practice/views/writing_practice_view.dart';
import '../modules/writing_practice/views/word_selection_view.dart';
import '../modules/writing_practice/views/word_practice_view.dart';
import '../modules/object_hunt/bindings/object_hunt_binding.dart';
import '../modules/object_hunt/bindings/object_hunt_selection_binding.dart';
import '../modules/object_hunt/views/object_hunt_selection_view.dart';
import '../modules/object_hunt/views/object_hunt_intro_view.dart';
import '../modules/object_hunt/views/object_hunt_camera_view.dart';
import '../modules/object_hunt/views/object_hunt_exam_intro_view.dart';
import '../modules/object_hunt/views/object_hunt_exam_camera_view.dart';
import '../modules/guess_object/bindings/guess_object_binding.dart';
import '../modules/guess_object/views/guess_object_camera_view.dart';
import '../modules/writing_practice/bindings/word_practice_binding.dart';
import '../modules/otp/bindings/otp_binding.dart';
import '../modules/otp/views/otp_view.dart';
import '../modules/activity_log/views/activity_log_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/multiplayer/bindings/multiplayer_battle_binding.dart';
import '../modules/multiplayer/views/multiplayer_menu_view.dart';
import '../modules/multiplayer/views/multiplayer_lobby_view.dart';
import '../modules/multiplayer/views/multiplayer_battle_view.dart';
import '../modules/writing_exam/views/writing_exam_menu_view.dart';
import '../modules/writing_exam/controllers/writing_exam_menu_controller.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
      opaque: false, // Membiarkan halaman sebelumnya terlihat (popup effect)
      transition: Transition.fadeIn,
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
      name: Routes.WRITING_EXAM_MENU,
      page: () => const WritingExamMenuView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<WritingExamMenuController>(() => WritingExamMenuController());
      }),
    ),
    GetPage(
      name: Routes.WORD_SELECTION,
      page: () => const WordSelectionView(),
    ),
    GetPage(
      name: Routes.WORD_PRACTICE,
      page: () => const WordPracticeView(),
      binding: WordPracticeBinding(),
    ),
    GetPage(
      name: Routes.SPELLING_PRACTICE,
      page: () => const SpellingPracticeView(),
      binding: SpellingPracticeBinding(),
    ),
    GetPage(
      name: Routes.SPELLING_LETTER_SELECTION,
      page: () => const SpellingLetterSelectionView(),
    ),
    GetPage(
      name: Routes.SPELLING_WORD_SELECTION,
      page: () => const SpellingWordSelectionView(),
    ),
    GetPage(
      name: Routes.SPELLING_EXAM,
      page: () => const SpellingExamView(),
      binding: SpellingExamBinding(),
    ),
    GetPage(
      name: Routes.SPELLING_CATEGORY,
      page: () => const SpellingCategoryView(),
    ),
    GetPage(
      name: Routes.SPELLING_EXAM_MENU,
      page: () => const SpellingExamMenuView(),
      binding: SpellingExamMenuBinding(),
    ),
    GetPage(
      name: Routes.SPELLING_EXAM_CATEGORY,
      page: () => const SpellingExamCategoryView(),
    ),
    GetPage(
      name: Routes.RAPORT,
      page: () => const RaportView(),
      binding: RaportBinding(),
    ),
    // Object Hunt
    GetPage(
      name: Routes.OBJECT_HUNT_SELECTION,
      page: () => const ObjectHuntSelectionView(),
      binding: ObjectHuntSelectionBinding(),
    ),
    GetPage(
      name: Routes.OBJECT_HUNT_INTRO,
      page: () => const ObjectHuntIntroView(),
      binding: ObjectHuntBinding(),
    ),
    GetPage(
      name: Routes.OBJECT_HUNT_CAMERA,
      page: () => const ObjectHuntCameraView(),
    ),
    GetPage(
      name: Routes.GUESS_OBJECT_CAMERA,
      page: () => const GuessObjectCameraView(),
      binding: GuessObjectBinding(),
    ),
    GetPage(
      name: Routes.OBJECT_HUNT_EXAM,
      page: () => const ObjectHuntExamIntroView(),
      binding: ObjectHuntExamBinding(),
    ),
    GetPage(
      name: Routes.OBJECT_HUNT_EXAM_CAMERA,
      page: () => const ObjectHuntExamCameraView(),
    ),
    GetPage(
      name: Routes.ACTIVITY_LOG,
      page: () => const ActivityLogView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
      transition: Transition.downToUp,
    ),
    // Multiplayer
    GetPage(
      name: Routes.MULTIPLAYER_MENU,
      page: () => const MultiplayerMenuView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.MULTIPLAYER_LOBBY,
      page: () => const MultiplayerLobbyView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.MULTIPLAYER_BATTLE,
      page: () => const MultiplayerBattleView(),
      binding: MultiplayerBattleBinding(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
