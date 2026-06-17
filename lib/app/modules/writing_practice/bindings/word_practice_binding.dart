import 'package:get/get.dart';
import '../controllers/word_practice_controller.dart';

class WordPracticeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<WordPracticeController>(WordPracticeController());
  }
}
