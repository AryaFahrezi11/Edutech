import 'dart:async';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../services/point_service.dart';
import '../../../services/log_service.dart';
import '../../../services/tts_service.dart';
import '../../../services/sfx_service.dart';
import '../../object_hunt/data/hunt_items.dart';

enum GuessState { scanning, locked, listening, success, failed }

class GuessObjectController extends GetxController {
  // State
  final currentState = GuessState.scanning.obs;
  
  // Object Detection
  final isCameraReady = false.obs;
  final isPermissionDenied = false.obs;
  final yoloController = YOLOViewController();
  final matchingResult = Rxn<YOLOResult>();
  final targetItem = Rxn<HuntItem>(); // The item currently locked
  
  DateTime? _firstDetectTime;

  // Speech to Text
  final stt.SpeechToText _speech = stt.SpeechToText();
  final isSpeechAvailable = false.obs;
  final recognizedText = "".obs;

  // Services
  final _pointService = Get.find<PointService>();
  final _logService = Get.find<LogService>();
  final _ttsService = Get.find<TtsService>();
  final _sfxService = Get.find<SfxService>();

  @override
  void onInit() {
    super.onInit();
    yoloController.setShowOverlays(false);
    
    // Suara sapaan awal
    Future.delayed(const Duration(milliseconds: 500), () {
      _ttsService.speak("Selamat datang di Tebak Benda! Arahkan kameramu ke benda di sekitarmu!");
    });
    
    _initPermissions();
  }

  Future<void> _initPermissions() async {
    final camStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (camStatus.isGranted) {
      isCameraReady.value = true;
    } else {
      isPermissionDenied.value = true;
    }

    if (micStatus.isGranted) {
      _initSpeech();
    }
  }

  Future<void> _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (val) {
        if (val == 'done' && currentState.value == GuessState.listening) {
          _verifySpeech();
        }
      },
      onError: (val) {
        // debugPrint('SpeechError: $val');
      },
    );
    isSpeechAvailable.value = available;
  }

  /// Dipanggil dari YOLOView saat ada objek terdeteksi
  void onYoloResult(List<YOLOResult> results) {
    if (currentState.value != GuessState.scanning) return;

    YOLOResult? bestMatch;
    HuntItem? matchedItem;

    // Cari benda dari daftar huntItems dengan confidence tertinggi
    for (final obj in results) {
      final label = obj.className.toLowerCase().trim();
      final conf = obj.confidence;
      
      if (conf > 0.65) {
        final found = huntItems.firstWhereOrNull((e) => e.nameEn.toLowerCase() == label);
        if (found != null) {
          if (bestMatch == null || conf > bestMatch.confidence) {
            bestMatch = obj;
            matchedItem = found;
          }
        }
      }
    }

    if (bestMatch != null && matchedItem != null) {
      matchingResult.value = bestMatch;
      
      if (_firstDetectTime == null) {
        _firstDetectTime = DateTime.now();
      } else {
        final diff = DateTime.now().difference(_firstDetectTime!);
        // Kunci jika benda stabil selama 1.5 detik
        if (diff.inMilliseconds > 1500) {
          _lockObject(bestMatch, matchedItem);
        }
      }
    } else {
      matchingResult.value = null;
      _firstDetectTime = null;
    }
  }

  void _lockObject(YOLOResult result, HuntItem item) async {
    currentState.value = GuessState.locked;
    targetItem.value = item;
    
    // Membekukan/meng-capture tampilan kamera agar anak fokus
    await yoloController.pause();
    
    // Suara bertanya
    _ttsService.speak("Wah, kamu menemukan sesuatu! Benda apakah ini?");
    
    // Tunggu 3.5 detik (estimasi panjang suara) lalu mulai mendengarkan
    Future.delayed(const Duration(milliseconds: 3500), () {
      _startListening();
    });
  }

  void _startListening() {
    if (!isSpeechAvailable.value) {
      // Fallback kalau speech error
      _ttsService.speak("Maaf, mikrofon tidak bisa digunakan saat ini.");
      return;
    }
    
    recognizedText.value = "";
    currentState.value = GuessState.listening;
    
    _speech.listen(
      onResult: (val) {
        recognizedText.value = val.recognizedWords;
      },
      listenOptions: stt.SpeechListenOptions(
        pauseFor: const Duration(seconds: 3), // Berhenti rekam kalau diam 3 detik
      ),
      localeId: 'id_ID', // Bahasa Indonesia
    );
  }

  void _verifySpeech() {
    if (currentState.value != GuessState.listening) return;
    
    final text = recognizedText.value.toLowerCase().trim();
    final targetName = targetItem.value!.nameId.toLowerCase().trim();
    
    // Pengecekan sederhana (mengandung kata utama)
    if (text.contains(targetName) || targetName.contains(text) && text.length > 2) {
      _onSuccess();
    } else {
      _onFailed();
    }
  }

  void _onSuccess() {
    currentState.value = GuessState.success;
    
    final reward = targetItem.value!.xpReward;
    _pointService.addPoints(reward);
    _sfxService.playCoin();
    
    _ttsService.speak("Hebat! Benar sekali, ini adalah ${targetItem.value!.nameId}!");
    
    _logService.addLog(
      "Tebak Benda",
      "Berhasil menebak ${targetItem.value!.nameId}",
      reward,
    );

    // Beri waktu selebrasi, lalu reset
    Future.delayed(const Duration(seconds: 4), () {
      resetScan();
    });
  }

  void _onFailed() {
    currentState.value = GuessState.failed;
    
    _ttsService.speak("Hmm, kurang tepat. Ayo coba ucapkan lagi!");
  }

  void retryListening() {
    if (currentState.value == GuessState.failed) {
      _startListening();
    }
  }

  void resetScan() {
    currentState.value = GuessState.scanning;
    targetItem.value = null;
    matchingResult.value = null;
    _firstDetectTime = null;
    recognizedText.value = "";
    _speech.stop();
    
    // Mengaktifkan kamera kembali
    yoloController.resume();
  }

  @override
  void onClose() {
    _speech.cancel();
    super.onClose();
  }
}
