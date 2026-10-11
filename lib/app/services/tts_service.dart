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
    try {
      if (GetPlatform.isAndroid) {
        await flutterTts.setEngine("com.google.android.tts");
      }
    } catch (e) {
      print("TTS setEngine fallback to default system engine: $e");
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
    isSpeaking.value = true;
    await flutterTts.speak(text);
  }

  Future<void> speakAndWait(String text) async {
    if (!isTtsEnabled.value) return;
    _ttsCompleter = Completer<void>();
    try {
      // Waktu perkiraan durasi bicara: ~75ms per karakter
      final int estimatedDurationMs = text.length * 85; 
      
      await flutterTts.speak(text).timeout(const Duration(seconds: 15));
      if (_ttsCompleter != null && !_ttsCompleter!.isCompleted) {
        // Tunggu completer dari engine, atau fallback waktu estimasi jika engine langsung selesai (bug flutter_tts di beberapa HP)
        await Future.any([
          _ttsCompleter!.future,
          Future.delayed(Duration(milliseconds: estimatedDurationMs)),
        ]).timeout(const Duration(seconds: 15));
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
