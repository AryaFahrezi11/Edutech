import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class BackgroundMusicService extends GetxService with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _shouldPlay = false; // Menyimpan status apakah musik SEHARUSNYA dimainkan saat ini
  
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    // Tidak dipanggil otomatis di awal agar tidak bunyi di splash screen
    _initBgm();
  }

  Future<void> _initBgm() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(0.3);
      await _audioPlayer.setSource(AssetSource('audio/sound.mp3'));
      _isInitialized = true;
    } catch (e) {
      print("Error memutar sound: $e");
    }
  }
  
  Future<void> playBgm() async {
    _shouldPlay = true;
    if (!_isInitialized) await _initBgm();
    if (!_isPlaying) {
      await _audioPlayer.resume();
      _isPlaying = true;
    }
  }

  void pauseBgm() {
    _shouldPlay = false;
    if (_isPlaying) {
      _audioPlayer.pause();
      _isPlaying = false;
    }
  }
  
  void resumeBgm() {
    playBgm();
  }
  
  void stopBgm() {
    _shouldPlay = false;
    _audioPlayer.stop();
    _isPlaying = false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.detached) {
      // Jika aplikasi masuk background (pindah aplikasi / layar mati), langsung pause musik
      if (_isPlaying) {
        _audioPlayer.pause();
        _isPlaying = false;
      }
    } else if (state == AppLifecycleState.resumed) {
      // Jika aplikasi kembali ke layar (foreground), mainkan lagi HANYA JIKA _shouldPlay true (ada di Home/Login)
      if (_shouldPlay && !_isPlaying && _isInitialized) {
        _audioPlayer.resume();
        _isPlaying = true;
      }
    }
  }
  
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    super.onClose();
  }
}
