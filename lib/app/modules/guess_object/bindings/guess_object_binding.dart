import 'package:get/get.dart';
import '../controllers/guess_object_controller.dart';

class GuessObjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuessObjectController>(
      () => GuessObjectController(),
    );
  }
}
