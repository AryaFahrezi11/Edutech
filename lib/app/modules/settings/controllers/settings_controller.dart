import 'package:get/get.dart';
import '../../../../app/services/sfx_service.dart';
import '../../../../app/services/tts_service.dart';

class SettingsController extends GetxController {
  final _sfxService = Get.find<SfxService>();
  final _ttsService = Get.find<TtsService>();

  // RxBool untuk UI reactivity
  RxBool get isSfxEnabled => _sfxService.isSfxEnabled;
  RxBool get isTtsEnabled => _ttsService.isTtsEnabled;

  void toggleSfx(bool val) {
    _sfxService.toggleSfx(val);
  }

  void toggleTts(bool val) {
    _ttsService.toggleTts(val);
  }
}
