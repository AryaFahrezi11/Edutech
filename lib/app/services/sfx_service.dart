import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SfxService extends GetxService {
  final AudioPlayer _successPlayer = AudioPlayer();
  final AudioPlayer _wrongPlayer = AudioPlayer();
  final AudioPlayer _coinPlayer = AudioPlayer();
  
  RxBool isSfxEnabled = true.obs;
  
  // Mengatur volume agar SFX terdengar jelas
  @override
  void onInit() {
    super.onInit();
    _successPlayer.setVolume(0.7); // Sedikit diturunkan agar balance dengan TTS
    _wrongPlayer.setVolume(0.7);
    _coinPlayer.setVolume(0.8);
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isSfxEnabled.value = prefs.getBool('sfx_enabled') ?? true;
  }

  Future<void> toggleSfx(bool val) async {
    isSfxEnabled.value = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sfx_enabled', val);
  }

  Future<void> playSuccess() async {
    if (!isSfxEnabled.value) return;
    try {
      await _successPlayer.play(AssetSource('audio/success.mp3'));
    } catch (e) {
      print("Gagal play success.mp3: $e");
    }
  }

  Future<void> playWrong() async {
    if (!isSfxEnabled.value) return;
    try {
      await _wrongPlayer.play(AssetSource('audio/wrong.mp3'));
    } catch (e) {
      print("Gagal play wrong.mp3: $e");
    }
  }

  Future<void> playCoin() async {
    if (!isSfxEnabled.value) return;
    try {
      // Untuk menghindari suara terpotong jika koin muncul berkali-kali cepat
      await _coinPlayer.stop();
      await _coinPlayer.play(AssetSource('audio/koin.mp3'));
    } catch (e) {
      print("Gagal play koin.mp3: $e");
    }
  }
}
