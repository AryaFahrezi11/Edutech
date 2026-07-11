import 'package:get/get.dart';
import '../../../services/tts_service.dart';

class LetterSelectionController extends GetxController {
  late List<String> letters;
  var category = 'uppercase'.obs;
  int? missionIndex;

  @override
  void onInit() {
    super.onInit();
    
    if (Get.arguments != null && Get.arguments['category'] != null) {
      category.value = Get.arguments['category'];
    }
    
    // Simpan mission_index jika ada
    if (Get.arguments != null && Get.arguments['mission_index'] != null) {
      missionIndex = Get.arguments['mission_index'];
    }

    if (category.value == 'lowercase') {
      letters = List.generate(26, (index) => String.fromCharCode(97 + index)); // a-z
    } else {
      letters = List.generate(26, (index) => String.fromCharCode(65 + index)); // A-Z
    }

    final tts = Get.find<TtsService>();
    tts.speak("Pilihlah huruf yang ingin kamu pelajari!");
  }
}
