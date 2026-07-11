import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_drawing/path_drawing.dart';
import '../data/letter_paths.dart';
import '../../../services/progress_service.dart';
import '../../../services/point_service.dart';
import '../../../services/tts_service.dart';
import '../../../services/sfx_service.dart';
import '../../../widgets/point_animation.dart';

class LetterData {
  final String letter;
  final Path fullPath;
  final List<PathMetric> metrics;
  
  int currentStrokeIndex = 0;
  double currentStrokeProgress = 0.0;
  List<Path> completedPaths = [];

  LetterData({
    required this.letter,
    required this.fullPath,
    required this.metrics,
  });
}

class WordPracticeController extends GetxController {
  late String word;
  
  var currentLetterIndex = 0.obs;
  var lettersData = <LetterData>[].obs;

  late int wordIndex;
  int? missionIndex;

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    
    word = Get.arguments?['word'] ?? 'BOLA';
    wordIndex = Get.arguments?['index'] ?? 0;
    missionIndex = Get.arguments?['mission_index'];
    _initLetters();
    _announceStart();
  }

  void _announceStart() async {
    final tts = Get.find<TtsService>();
    await tts.speakAndWait("Sekarang kita akan belajar menulis kata");
    await tts.speak("Kata $word");
  }

  void _initLetters() {
    List<LetterData> tempData = [];
    for (int i = 0; i < word.length; i++) {
      String char = word[i].toUpperCase();
      // Khusus untuk huruf I dan J, gunakan huruf kecil agar ada titiknya sesuai permintaan user
      // dan tidak ada sabuk/garis horizontal di atas/bawah
      if (char == 'I' || char == 'J') {
        char = char.toLowerCase();
      }

      String pathStr = '';
      if (char == 'i') {
        pathStr = LetterPaths.lowercasePaths['i'] ?? '';
      } else {
        pathStr = LetterPaths.uppercasePaths[char] ?? '';
      }
      
      Path path = pathStr.isNotEmpty ? parseSvgPathData(pathStr) : Path();
      List<PathMetric> metrics = path.computeMetrics().toList();
      
      tempData.add(LetterData(letter: char, fullPath: path, metrics: metrics));
    }
    lettersData.value = tempData;
    currentLetterIndex.value = 0;
  }

  void onPanUpdate(DragUpdateDetails details, int letterIndex) {
    if (letterIndex != currentLetterIndex.value) return; // Hanya bisa menggambar huruf yang aktif
    
    final data = lettersData[letterIndex];
    if (data.currentStrokeIndex >= data.metrics.length) return;
    
    final metric = data.metrics[data.currentStrokeIndex];
    final touchPosition = details.localPosition;
    
    const double snapRadius = 60.0; 
    
    double targetLength = (data.currentStrokeProgress * metric.length) + 15.0; 
    if (targetLength > metric.length) targetLength = metric.length;
    
    final tangent = metric.getTangentForOffset(targetLength);
    if (tangent != null) {
      final distance = (tangent.position - touchPosition).distance;
      if (distance < snapRadius) {
        data.currentStrokeProgress = targetLength / metric.length;
        
        if (data.currentStrokeProgress >= 0.98) {
          _completeCurrentStroke(data, metric, letterIndex);
        }
        
        // Memaksa update UI karena kita mengubah properti dalam object
        lettersData.refresh();
      }
    }
  }

  void _completeCurrentStroke(LetterData data, PathMetric metric, int letterIndex) {
    data.completedPaths.add(metric.extractPath(0, metric.length));
    data.currentStrokeIndex++;
    data.currentStrokeProgress = 0.0;
    
    // Jika seluruh huruf selesai
    if (data.currentStrokeIndex >= data.metrics.length) {
      if (currentLetterIndex.value < lettersData.length - 1) {
        // Lanjut ke huruf berikutnya
        currentLetterIndex.value++;
      } else {
        // Seluruh kata selesai
        checkGoresanAudit();
      }
    }
  }

  void onPanEnd(int letterIndex) {
    // Kosong, bisa diisi logika saat jari diangkat
  }

  void resetCanvas() {
    _initLetters();
  }

  void checkGoresanAudit() {
    // Advance progress
    Get.find<ProgressService>().completeWritingWord(wordIndex);
    
    if (missionIndex != null && Get.find<ProgressService>().unlockedWritingWord.value >= 5) {
      Get.find<ProgressService>().completeMissionNode(missionIndex!);
    }

    // Hitung Poin
    int earned = Get.find<PointService>().completeActivity('write_word_$word', isWord: true);

    Get.find<SfxService>().playSuccess();
    Get.find<TtsService>().speak("Luar biasa! Kamu berhasil menulis kata $word!");

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStar(delayedBy: 0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
                    child: _buildStar(delayedBy: 200, size: 70),
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
                "Kamu berhasil menulis kata '$word'!",
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
                    PointAnimation.showPointAnimation(earned, onComplete: () {
                      Get.back(); // Kembali ke pemilihan kata
                    });
                  },
                  child: const Text(
                    "Selesai",
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

  @override
  void onClose() {
    // Kembalikan ke mode Portrait saat keluar
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.onClose();
  }
}
