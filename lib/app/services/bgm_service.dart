import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

class BackgroundMusicService extends GetxService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  @override
  void onInit() {
    super.onInit();
    _initBgm();
  }

  void _initBgm() async {
    try {
      // Setup audio player to loop
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
      
      // Mengatur volume agar tidak terlalu keras (background)
      await _audioPlayer.setVolume(0.3);
      
      // Menggunakan file lokal MP3 yang sudah kita download
      await _audioPlayer.play(
        AssetSource('audio/sound.mp3'),
      );
      
    } catch (e) {
      print("Error memutar sound: $e");
    }
  }
  
  void pauseBgm() {
    _audioPlayer.pause();
  }
  
  void resumeBgm() {
    _audioPlayer.resume();
  }
  
  void stopBgm() {
    _audioPlayer.stop();
  }
  
  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
