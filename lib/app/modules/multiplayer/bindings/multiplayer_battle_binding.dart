import 'package:get/get.dart';
import '../controllers/multiplayer_battle_controller.dart';

class MultiplayerBattleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MultiplayerBattleController>(
      () => MultiplayerBattleController(),
    );
  }
}
