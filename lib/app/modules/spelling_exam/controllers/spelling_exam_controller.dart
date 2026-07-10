import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../services/tts_service.dart';
import '../../../services/sfx_service.dart';
import '../../../services/point_service.dart';
import '../../../services/progress_service.dart';
import '../../../widgets/point_animation.dart';
import '../../../services/gemini_service.dart';
import '../../../services/mongodb_service.dart';

enum ExamState { idle, countdown, listening, checking, evaluating, result }

class SpellingExamController extends GetxController with GetSingleTickerProviderStateMixin {
  final SpeechToText speech = SpeechToText();

  // GAMIFICATION ANIMATIONS
  late AnimationController animController;
  late Animation<double> starsAnim;

  // STATE
  final examState = ExamState.idle.obs;

  // SCORE VISUAL (hanya untuk tampilan koin di layar)
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

  static List<Map<String, dynamic>> getQuestionBank(String cat) {
    List<Map<String, dynamic>> capitals = [];
    List<Map<String, dynamic>> lowercases = [];
    
    for (int i = 0; i < 26; i++) {
      String letter = String.fromCharCode(65 + i);
      capitals.add({'answer': letter});
      lowercases.add({'answer': letter.toLowerCase()});
    }
    
    if (cat == 'word') {
      return [
        {'answer': 'KUCING', 'icon': '🐱'},
        {'answer': 'APEL', 'icon': '🍎'},
        {'answer': 'BOLA', 'icon': '⚽'},
        {'answer': 'KURSI', 'icon': '🪑'},
        {'answer': 'BOTOL', 'icon': '🍼'},
        {'answer': 'BUKU', 'icon': '📚'},
        {'answer': 'GELAS', 'icon': '🥛'},
        {'answer': 'TAS', 'icon': '🎒'},
        {'answer': 'JAM', 'icon': '⏰'},
        {'answer': 'LAPTOP', 'icon': '💻'},
        {'answer': 'GUNTING', 'icon': '✂️'},
        {'answer': 'MEJA', 'icon': '🪑'},
      ];
    } else if (cat == 'lowercase') {
      return lowercases;
    }
    return capitals;
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    category = args['category'] ?? 'capital';
    currentQuestionIndex.value = args['index'] ?? 0;
    
    // Inisialisasi awal
    speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (isListening.value) stopListening();
        }
      },
    );

    animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    starsAnim = CurvedAnimation(parent: animController, curve: Curves.elasticOut);
  }

  @override
  void onClose() {
    animController.dispose();
    super.onClose();
  }

  // GET CURRENT QUESTION
  Map<String, dynamic> get currentQuestion {
    final bank = getQuestionBank(category);
    if (currentQuestionIndex.value >= 0 && currentQuestionIndex.value < bank.length) {
      return bank[currentQuestionIndex.value];
    }
    return bank[0];
  }

  // TITLE
  String get examTitle {
    if (category == 'word') return 'Ujian Kata Mudah';
    if (category == 'lowercase') return 'Ujian Huruf Kecil';
    return 'Ujian Huruf Kapital';
  }

  // MULAI UJIAN / RESET KE IDLE
  void startExam() {
    examState.value = ExamState.idle;
    spokenText.value = '';
    isListening.value = false;
    speech.stop();
  }

  // Cek kecocokan huruf tunggal berdasarkan bunyi (fonetik)
  bool _isLetterMatch(String spoken, String target) {
    if (spoken.isEmpty) return false;
    
    var words = spoken.split(' ');
    
    // Cek huruf langsung sebagai kata terpisah agar tidak tembus jika ada kata "ayam" untuk target "a"
    if (words.contains(target) || spoken == target) return true;
    
    // Alias cara pengucapan anak-anak
    // Alias pengucapan fonetik (Indonesian & English STT fallback)
    final Map<String, List<String>> aliases = {
      'a': ['ah', 'aa', 'ha', 'i', 'a', 'uh', 'r', 'are'],
      'b': ['be', 'beh', 'bee', 'bi', 'b', 'bay', 'bear', 'bae', 'p'],
      'c': ['ce', 'ceh', 'ci', 'c', 'che', 'chay', 'she', 'say', 'see'],
      'd': ['de', 'deh', 'di', 'd', 'day', 'they', 'the', 'dee'],
      'e': ['eh', 'ee', 'e', 'a', 'hey'],
      'f': ['ef', 'ep', 'ev', 'f', 'eff', 'off', 'have'],
      'g': ['ge', 'geh', 'ji', 'g', 'gay', 'k', 'gee'],
      'h': ['ha', 'hah', 'h', 'huh', 'how'],
      'i': ['ih', 'ii', 'hi', 'i', 'e', 'ee', 'he'],
      'j': ['je', 'jeh', 'ja', 'j', 'jay', 'z', 'g'],
      'k': ['ka', 'kah', 'ke', 'k', 'car', 'cup', 'okay'],
      'l': ['el', 'le', 'l', 'all', 'hell'],
      'm': ['em', 'me', 'm', 'am', 'aim'],
      'n': ['en', 'ne', 'n', 'an', 'and', 'in'],
      'o': ['oh', 'oo', 'ho', 'o', 'or', 'aw'],
      'p': ['pe', 'peh', 'pi', 'p', 'pay', 'pee'],
      'q': ['ki', 'qi', 'kyu', 'ku', 'q', 'key', 'queue'],
      'r': ['er', 're', 'r', 'air', 'ear', 'are', 'error'],
      's': ['es', 'se', 's', 'ace', 'ash', 'is', 'yes'],
      't': ['te', 'teh', 'ti', 't', 'tay', 'the', 'tee'],
      'u': ['uh', 'uu', 'hu', 'u', 'oo', 'ooh', 'you'],
      'v': ['ve', 'veh', 'vi', 'fi', 'pi', 'v', 'vay', 'vee'],
      'w': ['we', 'weh', 'w', 'way', 'why'],
      'x': ['eks', 'ex', 'x', 'ax', 'axe'],
      'y': ['ye', 'yeh', 'ya', 'y', 'yay', 'why', 'yeah'],
      'z': ['zet', 'zed', 'jet', 'z', 'set', 'zee'],
    };

    if (aliases.containsKey(target)) {
      for (var alias in aliases[target]!) {
        if (words.contains(alias) || spoken == alias) return true;
      }
    }
    return false;
  }

  // START LISTENING
  Future<void> startListening() async {
    if (isListening.value) {
      stopListening();
      return;
    }

    if (speech.isAvailable || await speech.initialize()) {
      spokenText.value = '';
      isListening.value = true;
      examState.value = ExamState.listening;

      await speech.listen(
        localeId: category == 'word' ? 'id_ID' : 'en_US',
        partialResults: true,
        cancelOnError: false,
        onResult: (result) {
          spokenText.value = result.recognizedWords;
          
          String spoken = result.recognizedWords.toLowerCase();
          String target = currentQuestion['answer'].toString().toLowerCase();
          bool isWord = category == 'word';

          // Deteksi dini super cepat
          bool isMatch = isWord 
              ? spoken.contains(target) 
              : _isLetterMatch(spoken, target);

          if (isMatch) {
            stopListening();
          } 
          else if (result.hasConfidenceRating && result.confidence > 0) {
            stopListening();
          }
        },
      );
    } else {
      Get.snackbar("Akses Mikrofon", "Mohon izinkan mikrofon untuk menggunakan fitur ini.");
    }
  }

  // STOP LISTENING
  Future<void> stopListening() async {
    if (!isListening.value) return; // Mencegah checkAnswer terpanggil 2x
    isListening.value = false;
    try {
      speech.stop();
    } catch (e) {
      print("Error stop: $e");
    }
    checkAnswer();
  }

  // PLAY AUDIO
  void playAudio() {
    Get.snackbar("🔊 Audio", "Silakan ucapkan ${currentQuestion['answer']}");
  }

  // CHECK ANSWER
  void checkAnswer() async {
    examState.value = ExamState.checking;
    await Future.delayed(const Duration(seconds: 1)); // Dipercepat jadi 1 detik

    final correctAnswer = currentQuestion['answer'].toString().toLowerCase();
    final userAnswer = spokenText.value.toLowerCase().trim();

    bool answeredCorrectly = category == 'word'
        ? (userAnswer.contains(correctAnswer) || userAnswer == correctAnswer)
        : _isLetterMatch(userAnswer, correctAnswer);
        
    isCorrect.value = answeredCorrectly;

    if (answeredCorrectly) {
      examState.value = ExamState.result;
      
      final progressService = Get.find<ProgressService>();
      if (category == 'word') {
        progressService.completeSpellingExamWord(currentQuestionIndex.value);
      } else {
        progressService.completeSpellingExamLetter(currentQuestionIndex.value);
      }

      final String examId = 'exam_spelling_${category}_${currentQuestionIndex.value}';
      int earned = Get.find<PointService>().completeActivity(
        examId, 
        isExam: true, 
        isWord: category == 'word',
        stars: 3
      );

      score.value += earned;
      Get.find<SfxService>().playSuccess();
      animController.forward(from: 0); // Trigger animasi pop-up
      PointAnimation.showPointAnimation(earned, onComplete: () {}); // Panggil animasi koin
      await Get.find<TtsService>().speakAndWait("Wah, benar! Hebat sekali! Kamu dapat $earned bintang!");
    } else {
      examState.value = ExamState.evaluating;
      Get.find<SfxService>().playWrong();
      
      final geminiService = Get.find<GeminiService>();
      final mongoService = Get.find<MongoDbService>();
      
      final geminiResult = await geminiService.evaluateSpelling(
        targetWord: correctAnswer,
        spokenWord: userAnswer.isEmpty ? "(tidak bersuara)" : userAnswer,
      );

      examState.value = ExamState.result; // Tampilkan result screen (salah) agar bisa pencet tombol
      animController.forward(from: 0); // Trigger animasi pop-up

      if (geminiResult != null) {
        if (geminiResult['analytics_data'] != null) {
          await mongoService.saveAnalytics(geminiResult['analytics_data']);
        }
        
        final voiceFeedback = geminiResult['voice_feedback'] ?? "Aduh, masih kurang tepat. Coba ucapkan dengan lebih jelas ya!";
        await Get.find<TtsService>().speakAndWait(voiceFeedback);
      } else {
        await Get.find<TtsService>().speakAndWait("Aduh, masih kurang tepat. Coba ucapkan dengan lebih jelas ya!");
      }
    }
  }

  void backToMenu() {
    Get.back(result: true); // result: true agar map menu tahu ada progress/refresh
  }

  void goToNextLevel() {
    final bank = getQuestionBank(category);
    
    // Jika belum mencapai akhir soal
    if (currentQuestionIndex.value < bank.length - 1) {
      currentQuestionIndex.value++;
      startExam(); // Langsung mulai soal berikutnya
    } else {
      // Jika ini level terakhir, kembali ke menu
      Get.back(result: true);
    }
  }

  void retryLevel() {
    Get.find<TtsService>().stop();
    startExam();
  }
}
