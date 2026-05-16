import 'package:get/get.dart';
import '../controllers/writing_practice_controller.dart';

class WritingPracticeBinding extends Bindings {
  @override
  void dependencies() {
    // lazyPut memastikan controller hanya dimuat saat halaman ini dibuka,
    // sehingga memori aplikasi tetap ringan.
    Get.lazyPut<WritingPracticeController>(() => WritingPracticeController());
  }
}