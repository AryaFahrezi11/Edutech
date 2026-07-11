import 'package:flutter/material.dart' hide Ink;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../services/tts_service.dart';
import '../../../services/sfx_service.dart';
import '../../../services/point_service.dart';
import '../../../services/gemini_service.dart';
import '../../../services/mongodb_service.dart';
import '../../../services/progress_service.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';

enum ExamState { idle, drawing, checking, evaluating, result }

class WritingExamController extends GetxController
    with GetTickerProviderStateMixin {
  // ─── STATE ────────────────────────────────────────────────────────────────
  final examState = ExamState.idle.obs;
  final currentLetterIndex = 0.obs;
  final score = 0.obs;
  final isCorrect = false.obs;

  // ─── KATEGORI ──────────────────────────────────────────────────────────────
  final categoryTitle = 'Huruf Kapital'.obs;
  final isLandscape = false.obs; // true jika kategori membutuhkan landscape
  int? missionIndex;

  // Bank soal dibuat dinamis A-Z
  static Map<String, List<Map<String, dynamic>>> get questionBank {
    List<Map<String, dynamic>> capitals = [];
    List<Map<String, dynamic>> lowercases = [];
    
    for (int i = 0; i < 26; i++) {
      String letter = String.fromCharCode(65 + i);
      capitals.add({'letter': letter, 'hint': 'Tulis huruf $letter kapital', 'emoji': '✏️'});
      lowercases.add({'letter': letter.toLowerCase(), 'hint': 'Tulis huruf ${letter.toLowerCase()} kecil', 'emoji': '✏️'});
    }
    
    return {
      'capital': capitals,
      'lowercase': lowercases,
      'word': [
        {'letter': 'Bola', 'hint': 'Ditendang saat main bola', 'emoji': '⚽'},
        {'letter': 'Gigi', 'hint': 'Digunakan untuk mengunyah makanan', 'emoji': '🦷'},
        {'letter': 'Kucing', 'hint': 'Hewan lucu yang mengeong', 'emoji': '🐱'},
        {'letter': 'Mobil', 'hint': 'Kendaraan beroda empat', 'emoji': '🚗'},
        {'letter': 'Kursi', 'hint': 'Tempat untuk duduk', 'emoji': '🪑'},
        {'letter': 'Botol', 'hint': 'Tempat menyimpan air minum', 'emoji': '🍶'},
        {'letter': 'Buku', 'hint': 'Benda untuk dibaca', 'emoji': '📚'},
        {'letter': 'Gelas', 'hint': 'Wadah untuk minum air', 'emoji': '🥤'},
        {'letter': 'Tas', 'hint': 'Tempat menyimpan buku sekolah', 'emoji': '🎒'},
        {'letter': 'Jam', 'hint': 'Penunjuk waktu', 'emoji': '🕐'},
        {'letter': 'Laptop', 'hint': 'Komputer yang bisa dilipat', 'emoji': '💻'},
        {'letter': 'Gunting', 'hint': 'Alat memotong kertas', 'emoji': '✂️'},
        {'letter': 'Meja', 'hint': 'Tempat meletakkan barang', 'emoji': '🍽️'},
        {'letter': 'Handphone', 'hint': 'Alat komunikasi untuk menelepon', 'emoji': '📱'},
      ],

    };
  }

  // Soal yang sedang aktif
  Map<String, dynamic> get currentQuestion {
    final cat = Get.arguments?['category'] as String? ?? 'capital';
    final bank = questionBank[cat] ?? questionBank['capital']!;
    if (currentLetterIndex.value >= 0 && currentLetterIndex.value < bank.length) {
      return bank[currentLetterIndex.value];
    }
    return bank[0];
  }

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
      final idx = Get.arguments['index'] as int? ?? 0;
      missionIndex = Get.arguments['mission_index'] as int?;
      
      categoryTitle.value = title;
      currentLetterIndex.value = idx;
      
      if (cat == 'word') {
        isLandscape.value = true;
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    }
    
    _initDigitalInk();
    
    // Langsung mulai ujian karena sudah dipilih dari Menu Peta
    examState.value = ExamState.drawing;
    _announceStart();
  }

  final DigitalInkRecognizerModelManager _modelManager = DigitalInkRecognizerModelManager();
  DigitalInkRecognizer? _recognizer;

  Future<void> _initDigitalInk() async {
    const language = 'en-US'; // Gunakan en-US untuk akurasi pengenalan huruf Latin (A-Z, a-z) terbaik
    try {
      bool isDownloaded = await _modelManager.isModelDownloaded(language);
      if (!isDownloaded) {
        await _modelManager.downloadModel(language);
      }
      _recognizer = DigitalInkRecognizer(languageCode: language);
    } catch (e) {
      print('Gagal inisiasi Digital Ink: $e');
    }
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
    _recognizer?.close();
    super.onClose();
  }

  // ─── GETTERS ───────────────────────────────────────────────────────────────
  int get totalQuestions {
    final cat = Get.arguments?['category'] as String? ?? 'capital';
    final bank = questionBank[cat] ?? questionBank['capital']!;
    return bank.length;
  }
  
  bool get isLastQuestion {
    return currentLetterIndex.value >= totalQuestions - 1;
  }

  // ─── ACTIONS ───────────────────────────────────────────────────────────────
  void startExam() {
    examState.value = ExamState.drawing;
    score.value = 0;
    resetCanvas();
  }

  void onPanStart(DragStartDetails details) {
    if (examState.value != ExamState.drawing) return;
    userPoints.add(details.localPosition);
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (examState.value != ExamState.drawing) return;
    userPoints.add(details.localPosition);
  }

  void onPanEnd() {
    if (examState.value != ExamState.drawing) return;
    userPoints.add(null); // Penanda angkat tangan
  }

  void resetCanvas() {
    userPoints.clear();
  }

  void submitAnswer() async {
    if (userPoints.isEmpty) {
      Get.snackbar(
        'Belum Menggambar',
        'Coba tulis hurufnya dulu ya! ✏️',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: const Color(0xFF3A2F6B),
      );
      return;
    }

    examState.value = ExamState.checking;
    final ink = Ink();
    Stroke stroke = Stroke();
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    for (var point in userPoints) {
      if (point != null) {
        stroke.points.add(StrokePoint(
          x: point.dx,
          y: point.dy,
          t: timestamp,
        ));
      } else {
        if (stroke.points.isNotEmpty) {
          ink.strokes.add(stroke);
          stroke = Stroke();
        }
      }
    }
    if (stroke.points.isNotEmpty) {
      ink.strokes.add(stroke);
    }

    String recognizedText = "";
    bool isAnswerCorrect = false;
    final targetWord = currentQuestion['letter'] as String;

    if (_recognizer != null) {
      try {
        final candidates = await _recognizer!.recognize(ink);
        
        final topCandidates = candidates.take(2).toList();
        
        for (final candidate in topCandidates) {
          String candText = candidate.text.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').trim();
          String target = targetWord.toLowerCase().trim();
          
          if (target.length == 1) {
            if (candText == target) {
              recognizedText = candidate.text;
              isAnswerCorrect = true;
              break;
            }
          } else {
            if (candText.contains(target)) {
              recognizedText = candidate.text;
              isAnswerCorrect = true;
              break;
            }
          }
        }
        
        if (!isAnswerCorrect && candidates.isNotEmpty) {
          recognizedText = candidates.first.text;
        }
      } catch (e) {
        print("ML Kit Error: $e");
      }
    }

    isCorrect.value = isAnswerCorrect;

    if (isAnswerCorrect) {
      examState.value = ExamState.result;
      
      final progressService = Get.find<ProgressService>();
      final cat = Get.arguments?['category'] as String? ?? 'capital';
      if (cat == 'capital') {
        progressService.completeWritingExamLetter(currentLetterIndex.value);
      } else if (cat == 'lowercase') {
        progressService.completeWritingExamLowercase(currentLetterIndex.value);
      } else {
        progressService.completeWritingExamWord(currentLetterIndex.value);
      }

      if (missionIndex != null) {
        if (cat == 'capital' && progressService.unlockedWritingExamLetter.value >= 5) {
          progressService.completeMissionNode(missionIndex!);
        } else if (cat == 'lowercase' && progressService.unlockedWritingExamLowercase.value >= 5) {
          progressService.completeMissionNode(missionIndex!);
        } else if (cat == 'word' && progressService.unlockedWritingExamWord.value >= 5) {
          progressService.completeMissionNode(missionIndex!);
        }
      }

      final String examId = 'writing_exam_${cat}_${currentLetterIndex.value}';
      int earned = Get.find<PointService>().completeActivity(
        examId, 
        isExam: true, 
        isWord: cat == 'word',
        stars: 3
      );

      score.value += earned;
      starsAnimController.forward(from: 0);
      Get.find<SfxService>().playSuccess();

      // SIMPAN ANALITIK SUKSES
      Get.find<MongoDbService>().saveAnalytics({
        "mode": "writing",
        "target_word": targetWord,
        "written_word": targetWord,
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
      
      final geminiResult = await geminiService.evaluateWriting(
        targetWord: targetWord,
        writtenWord: recognizedText.isEmpty ? "(tidak terdeteksi)" : recognizedText,
      );

      if (geminiResult != null) {
        if (geminiResult['analytics_data'] != null) {
          await mongoService.saveAnalytics(geminiResult['analytics_data']);
        }
        
        final voiceFeedback = geminiResult['voice_feedback'] ?? "Aduh, masih kurang tepat. Tetap semangat ya!";
        await Get.find<TtsService>().speakAndWait(voiceFeedback);
      } else {
        await Get.find<TtsService>().speakAndWait("Aduh, masih kurang tepat. Coba tulis ulang dengan lebih pelan ya!");
      }
      
      resetCanvas();
      examState.value = ExamState.drawing;
    }
  }

  void goToNextLevel() {
    final cat = Get.arguments?['category'] as String? ?? 'capital';
    final bank = questionBank[cat] ?? questionBank['capital']!;
    
    // Jika belum mencapai akhir soal
    if (currentLetterIndex.value < bank.length - 1) {
      currentLetterIndex.value++;
      
      // Update unlocked index in progressService just to be safe 
      // (meskipun di submitAnswer sudah dibuka)
      
      resetCanvas();
      examState.value = ExamState.drawing;
    } else {
      // Jika ini level terakhir, kembali ke menu
      Get.back(result: true);
    }
  }

  void backToMenu() {
    Get.back(result: false);
  }

  void retryLevel() {
    resetCanvas();
    examState.value = ExamState.drawing;
  }

  void nextQuestion() {
    // Kembali ke peta menu agar anak bisa melihat progress huruf selanjutnya terbuka
    Get.back();
  }

  void retryExam() {
    startExam();
  }

  void exitExam() {
    Get.back(); // kembali ke home
  }
}
