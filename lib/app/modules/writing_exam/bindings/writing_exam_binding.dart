import 'package:get/get.dart';
import '../controllers/writing_exam_controller.dart';

class WritingExamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WritingExamController>(() => WritingExamController());
  }
}
