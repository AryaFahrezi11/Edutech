import 'package:get/get.dart';
import '../../../services/progress_service.dart';
import '../../../services/tts_service.dart';
import '../data/hunt_items.dart';

class ObjectHuntSelectionController extends GetxController {
  final items = huntItems;
  final progressService = Get.find<ProgressService>();
  final ttsService = Get.find<TtsService>();

  @override
  void onInit() {
    super.onInit();
    ttsService.speak("Pilihlah benda yang ingin kamu cari!");
  }

  void speakItemName(String name) {
    ttsService.speak(name);
  }
}
