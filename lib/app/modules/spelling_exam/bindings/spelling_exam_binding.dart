import 'package:get/get.dart';

import '../controllers/spelling_exam_controller.dart';

class SpellingExamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpellingExamController>(
      () => SpellingExamController(),
    );
  }
}
