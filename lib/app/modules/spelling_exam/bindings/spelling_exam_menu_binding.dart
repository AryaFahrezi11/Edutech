import 'package:get/get.dart';
import '../controllers/spelling_exam_menu_controller.dart';

class SpellingExamMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpellingExamMenuController>(
      () => SpellingExamMenuController(),
    );
  }
}
