import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../services/tts_service.dart';
import '../../../services/sfx_service.dart';
import '../../../services/point_service.dart';

enum ExamState { idle, countdown, listening, checking, result }

class SpellingExamController extends GetxController {
  final SpeechToText speech = SpeechToText();

  // STATE
  final examState = ExamState.idle.obs;

  // SCORE
  final score = 0.obs;

  // COUNTDOWN
  final countdown = 3.obs;

  // INDEX SOAL
  final currentQuestionIndex = 0.obs;

  // HASIL
  final isCorrect = false.obs;

  // MICROPHONE
  final isListening = false.obs;

  // HASIL SUARA USER
  final spokenText = ''.obs;

  // CATEGORY
  late String category;

  // DATA SOAL
  late List<Map<String, dynamic>> questions;

  @override
  void onInit() {
    super.onInit();

    initSpeech();

    final args = Get.arguments ?? {};

    category = args['category'] ?? 'capital';

    // ───── SOAL KATA ─────
    if (category == 'word') {
      questions = [
        {'answer': 'BOLA'},
        {'answer': 'BUKU'},
        {'answer': 'KUCING'},
        {'answer': 'MEJA'},
        {'answer': 'MOBIL'},
      ];
    }
    // ───── SOAL HURUF ─────
    else {
      questions = [
        {'answer': 'A'},
        {'answer': 'B'},
        {'answer': 'C'},
        {'answer': 'D'},
        {'answer': 'E'},
      ];
    }
    
    _announceStart();
  }

  void _announceStart() async {
    final tts = Get.find<TtsService>();
    if (category == 'word') {
      await tts.speak("Sekarang kita akan memulai ujian mengeja kata");
    } else {
      await tts.speak("Sekarang kita akan memulai ujian mengeja huruf");
    }
  }

  // INIT SPEECH
  Future<void> initSpeech() async {
    await speech.initialize();
  }

  // GET CURRENT QUESTION
  Map<String, dynamic> get currentQuestion =>
      questions[currentQuestionIndex.value];

  // LAST QUESTION
  bool get isLastQuestion => currentQuestionIndex.value == questions.length - 1;

  // TITLE
  String get examTitle {
    if (category == 'word') {
      return 'Ujian Kata Mudah';
    }

    return 'Ujian Huruf Kapital';
  }

  // MULAI UJIAN
  void startExam() async {
    examState.value = ExamState.countdown;

    countdown.value = 3;

    for (int i = 3; i > 0; i--) {
      countdown.value = i;

      await Future.delayed(const Duration(seconds: 1));
    }

    examState.value = ExamState.listening;
  }

  // START LISTENING
  Future<void> startListening() async {
    spokenText.value = '';

    isListening.value = true;

    await speech.listen(
      onResult: (result) {
        spokenText.value = result.recognizedWords;
      },
    );
  }

  // STOP LISTENING
  Future<void> stopListening() async {
    await speech.stop();

    isListening.value = false;

    checkAnswer();
  }

  // PLAY AUDIO
  void playAudio() {
    Get.snackbar("🔊 Audio", "Silakan ucapkan ${currentQuestion['answer']}");
  }

  // CHECK ANSWER
  void checkAnswer() async {
    examState.value = ExamState.checking;

    await Future.delayed(const Duration(seconds: 2));

    final correctAnswer = currentQuestion['answer'].toString().toLowerCase();

    final userAnswer = spokenText.value.toLowerCase().trim();

    if (userAnswer.contains(correctAnswer)) {
      isCorrect.value = true;
      score.value += 20;
      Get.find<SfxService>().playSuccess();
      Get.find<TtsService>().speak("Pintar! Jawabanmu benar!");
    } else {
      isCorrect.value = false;
      Get.find<SfxService>().playWrong();
      Get.find<TtsService>().speak("Belum tepat. Tidak apa-apa, ayo coba lagi nanti!");
    }

    // Jika soal terakhir, ucapkan selesai
    if (isLastQuestion) {
      examState.value = ExamState.idle;
      _showFinalResult();
    }
  }

  void _showFinalResult() {
    final int total = questions.length * 20;
    final percent = (score.value / total * 100).round();
    
    // Hitung bintang
    int stars = 1;
    if (percent >= 80) stars = 3;
    else if (percent >= 60) stars = 2;

    // Tambah poin
    final String examId = 'exam_spelling_$category';
    int earned = Get.find<PointService>().completeActivity(examId, isExam: true, stars: stars);

    Get.find<TtsService>().speak("Hore! Ujian selesai! Kamu mendapat tambahan $earned poin!");
    Get.dialog(
      _FinalResultDialog(score: score.value, total: total, earnedPoints: earned),
      barrierDismissible: false,
    );
  }

  void retryExam() {
    Get.back(); // tutup dialog
    score.value = 0;
    currentQuestionIndex.value = 0;
    startExam();
  }

  void exitExam() {
    Get.back(); // tutup dialog
    Get.back(); // kembali ke home
  }

  // NEXT
  void nextQuestion() async {
    if (isLastQuestion) {
      return;
    }

    currentQuestionIndex.value++;
    spokenText.value = '';
    examState.value = ExamState.countdown;
    countdown.value = 3;

    for (int i = 3; i > 0; i--) {
      countdown.value = i;
      await Future.delayed(const Duration(seconds: 1));
    }
    examState.value = ExamState.listening;
  }
}

// Dialog hasil akhir (disimpan di controller agar mudah diakses)
class _FinalResultDialog extends StatelessWidget {
  final int score;
  final int total;
  final int earnedPoints;
  const _FinalResultDialog({required this.score, required this.total, required this.earnedPoints});

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
            colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)],
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
                      Text('+$earnedPoints',
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w900, color: Color(0xFFFFD166))),
                      const Text('Poin XP', style: TextStyle(color: Colors.white70, fontSize: 13)),
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
                    onTap: Get.find<SpellingExamController>().retryExam,
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
                    onTap: Get.find<SpellingExamController>().exitExam,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text('🏠 Selesai',
                            style: TextStyle(
                                color: Color(0xFF1CB0F6),
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
