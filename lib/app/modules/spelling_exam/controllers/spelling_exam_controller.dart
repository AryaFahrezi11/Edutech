import 'dart:async';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
    } else {
      isCorrect.value = false;
    }

    examState.value = ExamState.result;
  }

  // NEXT
  void nextQuestion() async {
    if (isLastQuestion) {
      Get.back();

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
