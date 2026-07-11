import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TtsService extends GetxService {
  final FlutterTts flutterTts = FlutterTts();
  Completer<void>? _ttsCompleter;
  
  // State untuk mendeteksi apakah AI sedang berbicara (berguna untuk sinkronisasi animasi mulut Lottie)
  final RxBool isSpeaking = false.obs;
  
  RxBool isTtsEnabled = true.obs;

  Future<TtsService> init() async {
    final prefs = await SharedPreferences.getInstance();
    isTtsEnabled.value = prefs.getBool('tts_enabled') ?? true;

    await flutterTts.setLanguage("id-ID");
    if (GetPlatform.isAndroid) {
      await flutterTts.setEngine("com.google.android.tts");
    }
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setPitch(1.1);
    await flutterTts.awaitSpeakCompletion(true); // Memastikan speak() mengembalikan future saat selesai
    
    
    flutterTts.setStartHandler(() {
      isSpeaking.value = true;
    });

    flutterTts.setCompletionHandler(() {
      isSpeaking.value = false;
      if (_ttsCompleter != null && !_ttsCompleter!.isCompleted) {
        _ttsCompleter!.complete();
      }
    });

    flutterTts.setErrorHandler((msg) {
      isSpeaking.value = false;
      if (_ttsCompleter != null && !_ttsCompleter!.isCompleted) {
        _ttsCompleter!.complete();
      }
    });

    return this;
  }
  
  Future<void> toggleTts(bool val) async {
    isTtsEnabled.value = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tts_enabled', val);
    if (!val) {
      stop();
    }
  }

  Future<void> speak(String text) async {
    if (!isTtsEnabled.value) return;
    await flutterTts.speak(text);
  }

  Future<void> speakAndWait(String text) async {
    if (!isTtsEnabled.value) return;
    _ttsCompleter = Completer<void>();
    try {
      // Timeout 15 detik untuk antisipasi kalimat yang cukup panjang dari AI
      await flutterTts.speak(text).timeout(const Duration(seconds: 15));
      if (_ttsCompleter != null && !_ttsCompleter!.isCompleted) {
        await _ttsCompleter!.future.timeout(const Duration(seconds: 15));
      }
    } catch (e) {
      isSpeaking.value = false;
      if (_ttsCompleter != null && !_ttsCompleter!.isCompleted) {
        _ttsCompleter!.complete();
      }
      print("TTS timeout/error, melanjutkan eksekusi...");
    }
  }
  
  void stop() {
    isSpeaking.value = false;
    flutterTts.stop();
  }
}
