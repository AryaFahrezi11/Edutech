import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class TtsService extends GetxService {
  final FlutterTts flutterTts = FlutterTts();
  Completer<void>? _ttsCompleter;

  Future<TtsService> init() async {
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setPitch(1.1);
    
    flutterTts.setCompletionHandler(() {
      if (_ttsCompleter != null && !_ttsCompleter!.isCompleted) {
        _ttsCompleter!.complete();
      }
    });
    return this;
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> speakAndWait(String text) async {
    _ttsCompleter = Completer<void>();
    await flutterTts.speak(text);
    if (_ttsCompleter != null) {
      await _ttsCompleter!.future;
    }
  }
  
  void stop() {
    flutterTts.stop();
  }
}
