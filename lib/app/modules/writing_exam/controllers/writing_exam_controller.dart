import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../services/tts_service.dart';
import '../../../services/sfx_service.dart';

enum ExamState { idle, countdown, drawing, checking, result }

class WritingExamController extends GetxController
    with GetTickerProviderStateMixin {
  // ─── STATE ────────────────────────────────────────────────────────────────
  final examState = ExamState.idle.obs;
  final currentLetterIndex = 0.obs;
  final score = 0.obs;
  final countdown = 3.obs;
  final isCorrect = false.obs;

  // ─── KATEGORI ──────────────────────────────────────────────────────────────
  final categoryTitle = 'Huruf Kapital'.obs;
  final isLandscape = false.obs; // true jika kategori membutuhkan landscape

  // Bank soal berdasarkan kategori
  static const Map<String, List<Map<String, dynamic>>> _questionBank = {
    'capital': [
      {'letter': 'A', 'hint': 'Seperti gunung kembar', 'emoji': '⛰️'},
      {'letter': 'B', 'hint': 'Dua perut di kanan', 'emoji': '🫃'},
      {'letter': 'C', 'hint': 'Bulan sabit', 'emoji': '🌙'},
      {'letter': 'D', 'hint': 'Pintu setengah lingkaran', 'emoji': '🚪'},
      {'letter': 'E', 'hint': 'Tiga rak bertumpuk', 'emoji': '📚'},
    ],
    'word': [
      {'letter': 'Kucing', 'hint': 'Hewan berbulu yang suka minum susu', 'emoji': '🐱'},
      {'letter': 'Meja', 'hint': 'Tempat kita meletakkan buku', 'emoji': '📖'},
      {'letter': 'Buku', 'hint': 'Sumber ilmu pengetahuan', 'emoji': '📚'},
      {'letter': 'Apel', 'hint': 'Buah berwarna merah atau hijau', 'emoji': '🍎'},
      {'letter': 'Bola', 'hint': 'Dipakai untuk bermain sepak bola', 'emoji': '⚽'},
    ],
  };

  // Soal yang sedang aktif
  List<Map<String, dynamic>> questions = [];

  // ─── CANVAS ────────────────────────────────────────────────────────────────
  var userPoints = <Offset?>[].obs;

  // ─── ANIMASI ───────────────────────────────────────────────────────────────
  late AnimationController starsAnimController;
  late Animation<double> starsAnim;

  @override
  void onInit() {
    super.onInit();
    starsAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    starsAnim = CurvedAnimation(
      parent: starsAnimController,
      curve: Curves.elasticOut,
    );

    if (Get.arguments != null) {
      final cat = Get.arguments['category'] as String? ?? 'capital';
      final title = Get.arguments['title'] as String? ?? 'Huruf Kapital';
      categoryTitle.value = title;
      questions = List.from(_questionBank[cat] ?? _questionBank['capital']!);

      if (cat == 'word') {
        isLandscape.value = true;
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    } else {
      questions = List.from(_questionBank['capital']!);
    }
    
    _announceStart();
  }

  void _announceStart() async {
    final tts = Get.find<TtsService>();
    if (isLandscape.value) {
      await tts.speak("Sekarang kita akan memulai ujian menulis kata");
    } else {
      await tts.speak("Sekarang kita akan memulai ujian menulis huruf");
    }
  }

  @override
  void onClose() {
    // Selalu kembalikan ke portrait saat meninggalkan halaman
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    starsAnimController.dispose();
    super.onClose();
  }

  // ─── GETTERS ───────────────────────────────────────────────────────────────
  Map<String, dynamic> get currentQuestion =>
      questions[currentLetterIndex.value];
  bool get isLastQuestion =>
      currentLetterIndex.value >= questions.length - 1;

  // ─── ACTIONS ───────────────────────────────────────────────────────────────
  void startExam() {
    examState.value = ExamState.countdown;
    currentLetterIndex.value = 0;
    score.value = 0;
    _startCountdown();
  }

  void _startCountdown() {
    countdown.value = 3;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      countdown.value--;
      if (countdown.value <= 0) {
        examState.value = ExamState.drawing;
        resetCanvas();
        return false;
      }
      return true;
    });
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (examState.value != ExamState.drawing) return;
    userPoints.add(details.localPosition);
  }

  void onPanEnd() {
    if (examState.value != ExamState.drawing) return;
    userPoints.add(null);
  }

  void resetCanvas() {
    userPoints.clear();
  }

  void submitAnswer() async {
    if (userPoints.isEmpty) {
      Get.snackbar(
        '✏️ Hei!',
        'Tulis dulu hurufnya ya!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
        borderRadius: 20,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    examState.value = ExamState.checking;

    // Simulasi pengecekan AI
    await Future.delayed(const Duration(milliseconds: 1500));

    // Simulasi: anggap jawaban benar jika cukup banyak coretan
    final isAnswerCorrect = userPoints.whereType<Offset>().length > 30;
    isCorrect.value = isAnswerCorrect;

    if (isAnswerCorrect) {
      score.value += 20;
      starsAnimController.forward(from: 0);
      Get.find<SfxService>().playSuccess();
      Get.find<TtsService>().speak("Wah, benar! Hebat sekali!");
    } else {
      Get.find<SfxService>().playWrong();
      Get.find<TtsService>().speak("Aduh, masih kurang tepat. Tetap semangat ya!");
    }

    examState.value = ExamState.result;
  }

  void nextQuestion() {
    if (isLastQuestion) {
      examState.value = ExamState.idle;
      _showFinalResult();
      return;
    }
    currentLetterIndex.value++;
    examState.value = ExamState.countdown;
    _startCountdown();
  }

  void _showFinalResult() {
    Get.find<TtsService>().speak("Hore! Ujian selesai! Kamu mendapat nilai ${score.value}");
    Get.dialog(
      _FinalResultDialog(score: score.value, total: questions.length * 20),
      barrierDismissible: false,
    );
  }

  void retryExam() {
    Get.back(); // tutup dialog
    startExam();
  }

  void exitExam() {
    Get.back(); // tutup dialog
    Get.back(); // kembali ke home
  }
}

// Dialog hasil akhir (disimpan di controller agar mudah diakses)
class _FinalResultDialog extends StatelessWidget {
  final int score;
  final int total;
  const _FinalResultDialog({required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    final percent = (score / total * 100).round();
    final emoji = percent >= 80 ? '🏆' : percent >= 60 ? '⭐' : '💪';
    final message = percent >= 80
        ? 'Luar biasa! Kamu hebat!'
        : percent >= 60
            ? 'Bagus! Terus berlatih!'
            : 'Jangan menyerah, coba lagi!';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            const Text(
              'Ujian Selesai!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text('$score',
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white)),
                      const Text('Nilai', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    children: [
                      Text('$percent%',
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white)),
                      const Text('Skor', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: Get.find<WritingExamController>().retryExam,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text('🔄 Ulangi',
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: Get.find<WritingExamController>().exitExam,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text('🏠 Selesai',
                            style: TextStyle(
                                color: Color(0xFF6C63FF),
                                fontWeight: FontWeight.w800,
                                fontSize: 15)),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
