import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import '../../../services/point_service.dart';
import '../../../services/log_service.dart';
import '../data/hunt_items.dart';

class ObjectHuntExamController extends GetxController {
  static const int examDurationSeconds = 60;
  static const int itemsToFind = 5;

  final targetItem = Rxn<HuntItem>();
  final currentIndex = 0.obs;

  // State deteksi
  final isFound = false.obs;
  final detectedLabel = ''.obs;
  final confidence = 0.0.obs;

  // Timer state
  final timeLeft = examDurationSeconds.obs;
  final isCameraReady = false.obs;
  final isPermissionDenied = false.obs;
  
  final matchingResult = Rxn<YOLOResult>();
  final yoloController = YOLOViewController();

  final isExamActive = false.obs;
  final isExamFinished = false.obs;
  Timer? _timer;

  // Hasil ujian
  final foundCount = 0.obs;
  final totalTarget = itemsToFind;

  late final List<HuntItem> examItems;

  final _pointService = Get.find<PointService>();
  final _logService = Get.find<LogService>();

  @override
  void onInit() {
    super.onInit();
    // Matikan overlay bawaan
    yoloController.setShowOverlays(false);
    
    examItems = List.from(huntItems)..shuffle();
    // Ambil hanya sejumlah item yang ditarget
    examItems.retainWhere((_) => true); // shuffle sudah dilakukan
    _loadNextItem();
    _startTimer();
  }

  void _startTimer() {
    isExamActive.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft.value <= 0) {
        _endExam();
      } else {
        timeLeft.value--;
      }
    });
  }

  void _loadNextItem() {
    if (currentIndex.value < itemsToFind && currentIndex.value < examItems.length) {
      targetItem.value = examItems[currentIndex.value];
      isFound.value = false;
      detectedLabel.value = '';
      confidence.value = 0.0;
    } else {
      _endExam();
    }
  }

  /// Dipanggil setiap frame dari YOLOView
  void onYoloResult(List<YOLOResult> results) {
    if (isFound.value || !isExamActive.value || targetItem.value == null) return;

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
      detectedLabel.value = targetItem.value!.nameId; // Bahasa anak
      confidence.value = bestMatch.confidence;

      if (bestMatch.confidence >= 0.70) {
        _onItemFound();
      }
    } else {
      matchingResult.value = null; // Hilangkan kotak
    }
  }

  void _onItemFound() {
    isFound.value = true;
    foundCount.value++;

    final item = targetItem.value!;
    _logService.addLog(
      "Ujian Berburu Benda",
      "Menemukan ${item.nameId} ${item.emoji} dalam ujian!",
      0, // Poin diberikan di akhir ujian
    );

    // Delay sebentar sebelum lanjut ke item berikutnya
    Future.delayed(const Duration(seconds: 2), () {
      if (isExamActive.value) {
        currentIndex.value++;
        _loadNextItem();
      }
    });
  }

  void _endExam() {
    _timer?.cancel();
    isExamActive.value = false;
    isExamFinished.value = true;

    // Hitung bintang berdasarkan berapa benda yang ditemukan
    int stars;
    if (foundCount.value >= 5) {
      stars = 3;
    } else if (foundCount.value >= 3) {
      stars = 2;
    } else {
      stars = 1;
    }

    // Berikan poin
    final earned = _pointService.completeActivity(
      'hunt_exam_${foundCount.value}',
      isExam: true,
      stars: stars,
    );

    _logService.addLog(
      "Ujian Berburu Benda",
      "Selesai! Berhasil menemukan ${foundCount.value} dari $itemsToFind benda ⭐${'⭐' * (stars - 1)}",
      earned,
    );

    // Tampilkan dialog hasil
    _showResultDialog(stars, earned);
  }

  void _showResultDialog(int stars, int earned) {
    String starStr = '⭐' * stars;
    String message;
    if (stars == 3) {
      message = "Luar biasa! Semua benda berhasil kamu temukan!";
    } else if (stars == 2) {
      message = "Bagus! Kamu menemukan ${foundCount.value} dari $itemsToFind benda!";
    } else {
      message = "Semangat! Terus berlatih menemukan benda di sekitarmu!";
    }

    Get.defaultDialog(
      title: "$starStr Hasil Ujian $starStr",
      titleStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
      middleText: "$message\n\n+$earned XP didapat!",
      middleTextStyle: const TextStyle(fontSize: 14),
      backgroundColor: Colors.white,
      radius: 24,
      textConfirm: "Kembali ke Peta",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF6C63FF),
      onConfirm: () => Get.offAllNamed('/home'),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
