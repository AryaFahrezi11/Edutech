import 'package:get/get.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../services/point_service.dart';
import '../../../services/progress_service.dart';
import '../../../services/log_service.dart';
import '../data/hunt_items.dart';

class ObjectHuntController extends GetxController {
  // Benda yang harus dicari pada sesi ini (default latihan = 1 per sesi)
  final targetItem = Rxn<HuntItem>();
  final currentIndex = 0.obs;

  // State deteksi
  final isDetecting = false.obs;
  final isFound = false.obs;
  final detectedLabel = ''.obs;
  final confidence = 0.0.obs;
  final isCameraReady = false.obs;
  final isPermissionDenied = false.obs;

  // Menyimpan hasil deteksi benda target saat ini untuk digambar manual
  final matchingResult = Rxn<YOLOResult>();
  final yoloController = YOLOViewController();

  // Progres latihan (berapa benda sudah ditemukan dari total)
  final foundCount = 0.obs;
  final totalItems = huntItems.length;

  // Shuffle daftar benda agar urutannya acak setiap sesi
  late final List<HuntItem> sessionItems;

  final _pointService = Get.find<PointService>();
  final _progressService = Get.find<ProgressService>();
  final _logService = Get.find<LogService>();

  @override
  void onInit() {
    super.onInit();
    // Matikan overlay bawaan dari package
    yoloController.setShowOverlays(false);
    
    // Acak urutan benda supaya tidak membosankan
    sessionItems = List.from(huntItems)..shuffle();
    _loadNextItem();
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

  void _loadNextItem() {
    if (currentIndex.value < sessionItems.length) {
      targetItem.value = sessionItems[currentIndex.value];
      isFound.value = false;
      detectedLabel.value = '';
      confidence.value = 0.0;
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
        isFound.value = true;
        _pointService.addPoints(10);
        foundCount.value++;
        
        // Catat aktivitas di log
        _logService.addLog(
          "Berhasil menemukan ${targetItem.value!.nameId} di Latihan Berburu!",
          "practice",
          10,
        );

        Future.delayed(const Duration(seconds: 2), () {
          _loadNextItem();
        });
      }
    } else {
      matchingResult.value = null; // Hilangkan kotak jika target hilang
    }
  }

  void _onItemFound() {
    isFound.value = true;
    foundCount.value++;

    final item = targetItem.value!;
    final earned = _pointService.completeActivity(
      'hunt_${item.id}',
      isWord: false,
      isExam: false,
    );

    _logService.addLog(
      "Berburu Benda",
      "Berhasil menemukan ${item.nameId} ${item.emoji}!",
      earned,
    );

    // Update progres kunci latihan
    _progressService.completeObjectHunt(currentIndex.value);
  }

  /// User tap "Lanjut" setelah berhasil menemukan satu benda
  void goNext() {
    currentIndex.value++;
    if (currentIndex.value >= sessionItems.length) {
      // Selesai semua — kembali ke home
      Get.offAllNamed('/home');
    } else {
      _loadNextItem();
    }
  }

  /// User tap "Lewati" (skip) benda ini
  void skipItem() {
    currentIndex.value++;
    if (currentIndex.value >= sessionItems.length) {
      Get.offAllNamed('/home');
    } else {
      _loadNextItem();
    }
  }
}
