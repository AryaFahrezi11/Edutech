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
  int? missionIndex;

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
        {'answer': 'BOLA', 'icon': '⚽'},
        {'answer': 'GIGI', 'icon': '🦷'},
        {'answer': 'KUCING', 'icon': '🐱'},
        {'answer': 'MOBIL', 'icon': '🚗'},
        {'answer': 'KURSI', 'icon': '🪑'},
        {'answer': 'BOTOL', 'icon': '🍶'},
        {'answer': 'BUKU', 'icon': '📚'},
        {'answer': 'GELAS', 'icon': '🥤'},
        {'answer': 'TAS', 'icon': '🎒'},
        {'answer': 'JAM', 'icon': '🕐'},
        {'answer': 'LAPTOP', 'icon': '💻'},
        {'answer': 'GUNTING', 'icon': '✂️'},
        {'answer': 'MEJA', 'icon': '🍽️'},
        {'answer': 'HANDPHONE', 'icon': '📱'},
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
    missionIndex = args['mission_index'];
    
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
  // Strategi: gunakan id_ID locale + minta anak bilang "huruf A"
  bool _isLetterMatch(String spoken, String target) {
    if (spoken.isEmpty) return false;
    
    // Normalisasi: hilangkan tanda baca dan trim
    spoken = spoken.replaceAll(RegExp(r'[^a-z0-9\s]'), '').trim();
    var words = spoken.split(' ');
    
    // 1. Cek exact match langsung
    if (words.contains(target) || spoken == target) return true;
    
    // 2. Cek pola "huruf X"
    if (spoken.contains('huruf $target') || spoken.contains('huruf ${target.toUpperCase()}')) return true;
    
    // 3. Alias pengucapan fonetik Indonesia
    final Map<String, List<String>> aliases = {
      'a': ['ah', 'aa', 'ha', 'a', 'huruf a', 'uh', 'ar'],
      'b': ['be', 'beh', 'bee', 'bi', 'b', 'bay', 'bae', 'huruf b', 'huruf be', 'pe'],
      'c': ['ce', 'ceh', 'ci', 'c', 'se', 'she', 'si', 'huruf c', 'huruf ce', 'see'],
      'd': ['de', 'deh', 'di', 'd', 'the', 'dee', 'huruf d', 'huruf de'],
      'e': ['eh', 'ee', 'e', 'i', 'hey', 'ye', 'huruf e'],
      'f': ['ef', 'ep', 'ev', 'f', 'eff', 'huruf f', 'huruf ef'],
      'g': ['ge', 'geh', 'ji', 'g', 'je', 'gee', 'huruf g', 'huruf ge'],
      'h': ['ha', 'hah', 'h', 'huh', 'huruf h', 'huruf ha', 'aha'],
      'i': ['ih', 'ii', 'hi', 'i', 'e', 'ee', 'he', 'ai', 'huruf i'],
      'j': ['je', 'jeh', 'ja', 'j', 'jay', 'jey', 'huruf j', 'huruf je'],
      'k': ['ka', 'kah', 'ke', 'k', 'car', 'kay', 'okay', 'huruf k', 'huruf ka'],
      'l': ['el', 'le', 'l', 'all', 'huruf l', 'huruf el', 'al'],
      'm': ['em', 'me', 'm', 'am', 'aim', 'huruf m', 'huruf em'],
      'n': ['en', 'ne', 'n', 'an', 'huruf n', 'huruf en'],
      'o': ['oh', 'oo', 'ho', 'o', 'or', 'huruf o', 'kok'],
      'p': ['pe', 'peh', 'pi', 'p', 'pay', 'pee', 'huruf p', 'huruf pe'],
      'q': ['ki', 'qi', 'kyu', 'ku', 'q', 'kiu', 'huruf q', 'huruf ki'],
      'r': ['er', 're', 'r', 'air', 'ear', 'are', 'huruf r', 'huruf er'],
      's': ['es', 'se', 's', 'ace', 'huruf s', 'huruf es', 'as'],
      't': ['te', 'teh', 'ti', 't', 'tay', 'tee', 'the', 'huruf t', 'huruf te'],
      'u': ['uh', 'uu', 'hu', 'u', 'oo', 'ooh', 'you', 'huruf u'],
      'v': ['ve', 'veh', 'vi', 'fi', 'v', 'vee', 'fee', 'huruf v', 'huruf ve'],
      'w': ['we', 'weh', 'w', 'way', 'double', 'huruf w', 'huruf we'],
      'x': ['eks', 'ex', 'x', 'ax', 'axe', 'iks', 'huruf x', 'huruf eks'],
      'y': ['ye', 'yeh', 'ya', 'y', 'yay', 'yeah', 'yak', 'huruf y', 'huruf ye'],
      'z': ['zet', 'zed', 'jet', 'z', 'set', 'zee', 'sed', 'huruf z', 'huruf zet'],
    };

    if (aliases.containsKey(target)) {
      for (var alias in aliases[target]!) {
        if (words.contains(alias)) return true;
        if (alias.length >= 2 && spoken.contains(alias)) return true;
      }
    }
    
    // 4. Fallback: cek huruf pertama dari ucapan
    if (spoken.isNotEmpty && spoken[0] == target && spoken.length <= 3) return true;
    
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
      
      bool isWord = category == 'word';
      
      // Beri instruksi suara ke anak untuk mode huruf
      if (!isWord) {
        Get.find<TtsService>().speak("Coba bilang: huruf ${currentQuestion['answer']}");
        await Future.delayed(const Duration(milliseconds: 1500));
      }

      await speech.listen(
        // Gunakan id_ID untuk semua mode karena anak-anak Indonesia
        localeId: 'id_ID',
        partialResults: true,
        cancelOnError: false,
        // Beri waktu lebih lama agar engine punya cukup audio
        listenFor: const Duration(seconds: 8),
        pauseFor: const Duration(seconds: 3),
        onResult: (result) {
          spokenText.value = result.recognizedWords;
          
          String spoken = result.recognizedWords.toLowerCase();
          String target = currentQuestion['answer'].toString().toLowerCase();

          // Deteksi dini super cepat
          bool isMatch = isWord 
              ? spoken.contains(target) 
              : _isLetterMatch(spoken, target);

          if (isMatch) {
            stopListening();
          } 
          else if (result.finalResult && spoken.isNotEmpty) {
            // Hanya selesaikan jika ini BENAR-BENAR final result
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

      if (missionIndex != null) {
        if (category == 'word' && progressService.unlockedSpellingExamWord.value >= 5) {
          progressService.completeMissionNode(missionIndex!);
        } else if (category != 'word' && progressService.unlockedSpellingExamLetter.value >= 5) {
          progressService.completeMissionNode(missionIndex!);
        }
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
      
      // SIMPAN ANALITIK SUKSES
      Get.find<MongoDbService>().saveAnalytics({
        "mode": "spelling",
        "target_word": currentQuestion['answer'],
        "written_word": currentQuestion['answer'],
        "accuracy_score": 100,
        "error_type": "benar",
        "wrong_letters": []
      });

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
