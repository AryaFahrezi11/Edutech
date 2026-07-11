import 'package:get/get.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../services/point_service.dart';
import '../../../services/progress_service.dart';
import '../../../services/log_service.dart';
import '../../../services/tts_service.dart';
import '../../../services/sfx_service.dart';
import '../../../services/mongodb_service.dart';
import '../data/hunt_items.dart';

class ObjectHuntController extends GetxController {
  // Benda yang sedang dicari
  final targetItem = Rxn<HuntItem>();
  int targetIndex = 0;
  int? missionIndex;

  // State deteksi
  final isFound = false.obs;
  final detectedLabel = ''.obs;
  final confidence = 0.0.obs;
  final isCameraReady = false.obs;
  final isPermissionDenied = false.obs;

  // Menyimpan hasil deteksi benda target saat ini untuk digambar manual
  final matchingResult = Rxn<YOLOResult>();
  final yoloController = YOLOViewController();

  final _pointService = Get.find<PointService>();
  final _progressService = Get.find<ProgressService>();
  final _logService = Get.find<LogService>();
  final _ttsService = Get.find<TtsService>();
  final _sfxService = Get.find<SfxService>();

  // Waktu pertama kali target terdeteksi secara konstan
  DateTime? _firstDetectTime;

  @override
  void onInit() {
    super.onInit();
    
    // Dapatkan data dari navigasi (Selection Menu)
    if (Get.arguments != null) {
      targetItem.value = Get.arguments['item'];
      targetIndex = Get.arguments['index'];
      missionIndex = Get.arguments['mission_index'];
      
      // Sapaan saat masuk ke layar intro pencarian benda
      if (targetItem.value != null) {
        _ttsService.speak("Carilah ${targetItem.value!.nameId} di sekitarmu!");
      }
    }
    
    // Matikan overlay bawaan dari package
    yoloController.setShowOverlays(false);
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      isCameraReady.value = true;
    } else {
      isPermissionDenied.value = true;
    }
  }

  /// Dipanggil setiap frame dari YOLOView melalui onResult callback
  void onYoloResult(List<YOLOResult> results) {
    if (isFound.value || targetItem.value == null) return;

    YOLOResult? bestMatch;

    for (final obj in results) {
      final label = obj.className.toLowerCase().trim();
      final conf = obj.confidence;

      // HANYA proses jika benda sesuai target
      if (label == targetItem.value!.nameEn.toLowerCase()) {
        if (bestMatch == null || conf > bestMatch.confidence) {
          bestMatch = obj;
        }
      }
    }

    if (bestMatch != null) {
      matchingResult.value = bestMatch;
      detectedLabel.value = targetItem.value!.nameId; // Gunakan bahasa anak
      confidence.value = bestMatch.confidence;

      if (bestMatch.confidence > 0.7) {
        if (_firstDetectTime == null) {
          _firstDetectTime = DateTime.now();
        } else {
          final diff = DateTime.now().difference(_firstDetectTime!);
          if (diff.inMilliseconds > 1500) {
            isFound.value = true;
            final reward = targetItem.value!.xpReward;
            _pointService.addPoints(reward);
            _sfxService.playCoin();
            
            _ttsService.speak("Yey, kamu berhasil menemukan ${targetItem.value!.nameId}! Hebat sekali!");
            
            // Catat aktivitas di log
            _logService.addLog(
              "Latihan Detektif Benda",
              "Berhasil menemukan ${targetItem.value!.nameId}!",
              reward,
            );

            // Simpan Analitik Sukses
            Get.find<MongoDbService>().saveAnalytics({
              "mode": "observasi",
              "target_word": targetItem.value!.nameId,
              "written_word": targetItem.value!.nameId,
              "accuracy_score": 100,
              "error_type": "benar",
              "wrong_letters": []
            });

            // Simpan progress
            _progressService.completeObjectHunt(targetIndex, huntItems.length);
            
            if (missionIndex != null && _progressService.completedObjectHuntItems.length >= 5) {
              _progressService.completeMissionNode(missionIndex!);
            }

            // Beri jeda lebih lama sedikit agar anak menikmati momen
            Future.delayed(const Duration(seconds: 4), () {
              // Kembali ke halaman pemilihan
              Get.back(); // Tutup CameraView
              Get.back(); // Tutup IntroView (kembali ke SelectionView)
            });
          }
        }
      } else {
        _firstDetectTime = null;
      }
    } else {
      matchingResult.value = null; // Hilangkan kotak jika target hilang
      _firstDetectTime = null;
    }
  }

}
