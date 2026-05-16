import 'package:get/get.dart';
import '../controllers/letter_selection_controller.dart';

class LetterSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LetterSelectionController>(() => LetterSelectionController());
  }
}
