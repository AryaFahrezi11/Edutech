import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class SfxService extends GetxService {
  final AudioPlayer _successPlayer = AudioPlayer();
  final AudioPlayer _wrongPlayer = AudioPlayer();
  final AudioPlayer _coinPlayer = AudioPlayer();
  
  // Mengatur volume agar SFX terdengar jelas
  @override
  void onInit() {
    super.onInit();
    _successPlayer.setVolume(1.0);
    _wrongPlayer.setVolume(1.0);
    _coinPlayer.setVolume(1.0);
  }

  Future<void> playSuccess() async {
    try {
      await _successPlayer.play(AssetSource('audio/success.mp3'));
    } catch (e) {
      print("Gagal play success.mp3: $e");
    }
  }

  Future<void> playWrong() async {
    try {
      await _wrongPlayer.play(AssetSource('audio/wrong.mp3'));
    } catch (e) {
      print("Gagal play wrong.mp3: $e");
    }
  }

  Future<void> playCoin() async {
    try {
      // Untuk menghindari suara terpotong jika koin muncul berkali-kali cepat
      await _coinPlayer.stop();
      await _coinPlayer.play(AssetSource('audio/koin.mp3'));
    } catch (e) {
      print("Gagal play koin.mp3: $e");
    }
  }
}
