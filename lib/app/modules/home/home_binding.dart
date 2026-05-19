import 'package:get/get.dart';
import 'home_controller.dart';
import '../leaderboard/controllers/leaderboard_controller.dart';
import '../profile/controllers/profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<LeaderboardController>(() => LeaderboardController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}