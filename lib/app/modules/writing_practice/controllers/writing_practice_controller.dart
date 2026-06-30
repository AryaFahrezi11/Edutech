import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_drawing/path_drawing.dart';
import '../data/letter_paths.dart';
import '../../../services/progress_service.dart';
import '../../../services/point_service.dart';
import '../../../services/tts_service.dart';
import '../../../services/sfx_service.dart';
import '../../../widgets/point_animation.dart';

class WritingPracticeController extends GetxController {
  var selectedLetter = 'A'.obs;
  
  // Progress dari 0.0 sampai 1.0 pada stroke yang sedang aktif
  var currentStrokeProgress = 0.0.obs;
  // Index stroke (garis) ke-berapa yang sedang dikerjakan anak
  var currentStrokeIndex = 0.obs;
  // Menyimpan path yang sudah selesai ditebalkan
  var completedPaths = <Path>[].obs;

  late Path currentLetterPath;
  late List<PathMetric> currentMetrics;

  // Daftar alfabet untuk tombol navigasi
  final List<String> alphabet = List.generate(26, (index) => String.fromCharCode(65 + index));

  @override
  void onInit() {
    super.onInit();
    
    if (Get.arguments != null && Get.arguments['letter'] != null) {
      selectedLetter.value = Get.arguments['letter'];
    }

    _loadCurrentLetterPath();
    _announceStart();
  }

  void _announceStart() async {
    final tts = Get.find<TtsService>();
    await tts.speakAndWait("Sekarang kita akan belajar menulis huruf");
    await tts.speak("Huruf ${selectedLetter.value}");
  }

  void _loadCurrentLetterPath() {
    final pathStr = LetterPaths.uppercasePaths[selectedLetter.value] ?? '';
    currentLetterPath = pathStr.isNotEmpty ? parseSvgPathData(pathStr) : Path();
    currentMetrics = currentLetterPath.computeMetrics().toList();
    
    currentStrokeIndex.value = 0;
    currentStrokeProgress.value = 0.0;
    completedPaths.clear();
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (currentStrokeIndex.value >= currentMetrics.length) return; // Sudah selesai semua
    
    final metric = currentMetrics[currentStrokeIndex.value];
    final touchPosition = details.localPosition;
    
    const double snapRadius = 60.0; 
    
    double targetLength = (currentStrokeProgress.value * metric.length) + 15.0; 
    if (targetLength > metric.length) targetLength = metric.length;
    
    final tangent = metric.getTangentForOffset(targetLength);
    if (tangent != null) {
      final distance = (tangent.position - touchPosition).distance;
      if (distance < snapRadius) {
        currentStrokeProgress.value = targetLength / metric.length;
        
        if (currentStrokeProgress.value >= 0.98) {
          _completeCurrentStroke(metric);
        }
      }
    }
  }

  void _completeCurrentStroke(PathMetric metric) {
    completedPaths.add(metric.extractPath(0, metric.length));
    currentStrokeIndex.value++;
    currentStrokeProgress.value = 0.0;
    
    if (currentStrokeIndex.value >= currentMetrics.length) {
      checkGoresanAudit();
    }
  }

  void onPanEnd() {
  }

  void resetCanvas() {
    _loadCurrentLetterPath();
  }

  void nextLetter() {
    int currentIndex = alphabet.indexOf(selectedLetter.value);
    if (currentIndex < alphabet.length - 1) {
      selectedLetter.value = alphabet[currentIndex + 1];
      _loadCurrentLetterPath();
      Get.find<TtsService>().speak("Huruf ${selectedLetter.value}");
    }
  }

  void prevLetter() {
    int currentIndex = alphabet.indexOf(selectedLetter.value);
    if (currentIndex > 0) {
      selectedLetter.value = alphabet[currentIndex - 1];
      _loadCurrentLetterPath();
      Get.find<TtsService>().speak("Huruf ${selectedLetter.value}");
    }
  }

  void checkGoresanAudit() {
    // Advance progress
    int currentIndex = alphabet.indexOf(selectedLetter.value);
    Get.find<ProgressService>().completeWritingLetter(currentIndex);

    // Hitung poin
    int earned = Get.find<PointService>().completeActivity('write_letter_${selectedLetter.value}');

    // Ucapkan selamat dan mainkan SFX!
    Get.find<SfxService>().playSuccess();
    Get.find<TtsService>().speak("Hebat! Kamu berhasil menulis huruf ${selectedLetter.value} dengan sangat baik!");

    // Tampilkan popup gamifikasi modern dengan 3 bintang
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 3 Bintang Berjejer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStar(delayedBy: 0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
                    child: _buildStar(delayedBy: 200, size: 70), // Bintang tengah lebih besar & tinggi
                  ),
                  _buildStar(delayedBy: 400),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Luar Biasa! 🎉",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1CB0F6),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Kamu berhasil menulis huruf ${selectedLetter.value} dengan sangat baik!",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1CB0F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    Get.back(); // Tutup popup bintang
                    // Tampilkan animasi koin, setelah selesai baru nextLetter
                    PointAnimation.showPointAnimation(earned, onComplete: () {
                      nextLetter();
                    });
                  },
                  child: const Text(
                    "Lanjut Belajar",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildStar({required int delayedBy, double size = 50}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Icon(Icons.star_rounded, color: const Color(0xFFFFD700), size: size),
        );
      },
    );
  }
}