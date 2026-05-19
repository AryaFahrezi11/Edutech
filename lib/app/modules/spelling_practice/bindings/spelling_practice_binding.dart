import 'package:get/get.dart';

import '../controllers/spelling_practice_controller.dart';

class SpellingPracticeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpellingPracticeController>(
      () => SpellingPracticeController(),
    );
  }
}
