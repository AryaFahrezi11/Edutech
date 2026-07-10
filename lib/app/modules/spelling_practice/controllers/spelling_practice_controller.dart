import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../services/progress_service.dart';
import '../../../services/point_service.dart';
import '../../../services/tts_service.dart';
import '../../../services/sfx_service.dart';
import '../../../widgets/point_animation.dart';


class SpellingPracticeController extends GetxController {
  final currentIndex = 0.obs;
  late String type;

  // TTS & STT
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText speech = stt.SpeechToText();
  
  var isListening = false.obs;
  var spokenText = "".obs;

  // Completer untuk menunggu TTS selesai bicara
  Completer<void>? _ttsCompleter;

  final letters = [
    {'upper': 'A', 'lower': 'a'},
    {'upper': 'B', 'lower': 'b'},
    {'upper': 'C', 'lower': 'c'},
    {'upper': 'D', 'lower': 'd'},
    {'upper': 'E', 'lower': 'e'},
    {'upper': 'F', 'lower': 'f'},
    {'upper': 'G', 'lower': 'g'},
    {'upper': 'H', 'lower': 'h'},
    {'upper': 'I', 'lower': 'i'},
    {'upper': 'J', 'lower': 'j'},
    {'upper': 'K', 'lower': 'k'},
    {'upper': 'L', 'lower': 'l'},
    {'upper': 'M', 'lower': 'm'},
    {'upper': 'N', 'lower': 'n'},
    {'upper': 'O', 'lower': 'o'},
    {'upper': 'P', 'lower': 'p'},
    {'upper': 'Q', 'lower': 'q'},
    {'upper': 'R', 'lower': 'r'},
    {'upper': 'S', 'lower': 's'},
    {'upper': 'T', 'lower': 't'},
    {'upper': 'U', 'lower': 'u'},
    {'upper': 'V', 'lower': 'v'},
    {'upper': 'W', 'lower': 'w'},
    {'upper': 'X', 'lower': 'x'},
    {'upper': 'Y', 'lower': 'y'},
    {'upper': 'Z', 'lower': 'z'},
  ];

  final words = [
    {'word': 'BOLA', 'spell': 'BO • LA', 'sound': 'BO... LA... BOLA', 'icon': '⚽'},
    {'word': 'BUKU', 'spell': 'BU • KU', 'sound': 'BU... KU... BUKU', 'icon': '📚'},
    {'word': 'MEJA', 'spell': 'ME • JA', 'sound': 'ME... JA... MEJA', 'icon': '🪑'},
    {'word': 'MOBIL', 'spell': 'MO • BIL', 'sound': 'MO... BIL... MOBIL', 'icon': '🚗'},
    {'word': 'KUCING', 'spell': 'KU • CING', 'sound': 'KU... CING... KUCING', 'icon': '🐱'},
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    type = args['type'] ?? 'letter';
    if (args['index'] != null) {
      currentIndex.value = args['index'];
    }
    
    _initTTS();
    _initSTT();
    _announceStart();
  }

  void _announceStart() async {
    final tts = Get.find<TtsService>();
    if (isLetterMode) {
      await tts.speakAndWait("Sekarang kita akan belajar mengeja huruf");
      await tts.speak("Huruf ${currentItem['upper']}");
    } else {
      await tts.speakAndWait("Sekarang kita akan belajar mengeja kata");
      await tts.speak("Kata ${currentWord['word']}");
    }
  }

  void _initTTS() async {
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(1.2);
    
    // Callback saat TTS selesai berbicara
    flutterTts.setCompletionHandler(() {
      _ttsCompleter?.complete();
    });
  }

  /// Speak dan tunggu sampai selesai diucapkan
  Future<void> _speakAndWait(String text) async {
    _ttsCompleter = Completer<void>();
    await flutterTts.speak(text);
    await _ttsCompleter!.future;
  }

  void _initSTT() async {
    await speech.initialize(
      onError: (error) => print('Error STT: $error'),
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (isListening.value) _verifyPronunciation();
        }
      },
    );
  }

  bool get isLetterMode => type == 'letter';
  bool get isWordMode => type == 'word';

  dynamic get currentItem => isLetterMode ? letters[currentIndex.value] : words[currentIndex.value];
  int get totalItem => isLetterMode ? letters.length : words.length;
  Map<String, dynamic> get currentWord => words[currentIndex.value];

  void nextItem() {
    if (currentIndex.value < totalItem - 1) {
      currentIndex.value++;
      Get.find<TtsService>().speak("Huruf ${currentItem['upper']}");
    }
  }
  void nextWord() {
    if (currentIndex.value < words.length - 1) {
      currentIndex.value++;
      Get.find<TtsService>().speak("Kata ${currentWord['word']}");
    }
  }
  void previousItem() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      Get.find<TtsService>().speak("Huruf ${currentItem['upper']}");
    }
  }
  void previousWord() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      Get.find<TtsService>().speak("Kata ${currentWord['word']}");
    }
  }

  // =========================================================
  // TEXT-TO-SPEECH (ROBOT SUARA)
  // =========================================================
  Future<void> playSound() async {
    if (isLetterMode) {
      await flutterTts.speak(currentItem['upper']);
    } else {
      await flutterTts.speak(currentItem['sound']);
    }
  }

  Future<void> speakSpell(String part) async {
    await flutterTts.speak(part);
  }

  Future<void> speakWord() async {
    await flutterTts.speak(currentWord['word']);
  }

  /// Mengeja kata secara lengkap: huruf per huruf → suku kata → kata utuh
  /// Contoh: "B. O. L. A. ... BO... LA... BOLA"
  var isSpelling = false.obs;

  Future<void> stopListening() async {
    if (!isListening.value) return; // Mencegah kepanggil 2x
    isListening.value = false;
    try {
      speech.stop();
    } catch (e) {
      print("Error stop: $e");
    }
    
    // Validasi final
    _verifyPronunciation();
  }

  Future<void> speakFullSpelling() async {
    if (isSpelling.value) return; // cegah double-tap
    isSpelling.value = true;

    final word = currentWord;
    final String fullWord = word['word'];
    final String spellStr = word['spell'];
    final spellParts = spellStr.split('•').map((e) => e.trim()).toList();

    // 1) Eja huruf satu per satu: B - O - L - A
    for (int i = 0; i < fullWord.length; i++) {
      await _speakAndWait(fullWord[i]);
      await Future.delayed(const Duration(milliseconds: 300));
    }

    await Future.delayed(const Duration(milliseconds: 500));

    // 2) Eja per suku kata: BO - LA
    for (final part in spellParts) {
      await _speakAndWait(part);
      await Future.delayed(const Duration(milliseconds: 400));
    }

    await Future.delayed(const Duration(milliseconds: 500));

    // 3) Ucapkan kata utuh: BOLA
    await _speakAndWait(fullWord);

    isSpelling.value = false;
  }

  // Cek kecocokan huruf tunggal berdasarkan bunyi (fonetik)
  bool _isLetterMatch(String spoken, String target) {
    if (spoken.isEmpty) return false;
    
    var words = spoken.split(' ');
    
    // Cek huruf langsung sebagai kata terpisah agar tidak tembus jika ada kata "ayam" untuk target "a"
    if (words.contains(target) || spoken == target) return true;
    
    // Alias pengucapan fonetik (Indonesian & English STT fallback)
    final Map<String, List<String>> aliases = {
      'a': ['ah', 'aa', 'ha', 'i', 'a', 'uh', 'r', 'are', 'ei'],
      'b': ['be', 'beh', 'bee', 'bi', 'b', 'bay', 'bear', 'bae', 'p'],
      'c': ['ce', 'ceh', 'ci', 'c', 'che', 'chay', 'she', 'say', 'see'],
      'd': ['de', 'deh', 'di', 'd', 'day', 'they', 'the', 'dee'],
      'e': ['eh', 'ee', 'e', 'a', 'hey', 'i'],
      'f': ['ef', 'ep', 'ev', 'f', 'eff', 'off', 'have'],
      'g': ['ge', 'geh', 'ji', 'g', 'gay', 'k', 'gee'],
      'h': ['ha', 'hah', 'h', 'huh', 'how', 'age'],
      'i': ['ih', 'ii', 'hi', 'i', 'e', 'ee', 'he', 'ai'],
      'j': ['je', 'jeh', 'ja', 'j', 'jay', 'z', 'g'],
      'k': ['ka', 'kah', 'ke', 'k', 'car', 'cup', 'okay', 'kay'],
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
      'w': ['we', 'weh', 'w', 'way', 'why', 'double u'],
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

  // =========================================================
  // SPEECH-TO-TEXT (MIKROFON ANAK)
  // =========================================================
  void listen() async {
    if (!isListening.value) {
      if (speech.isAvailable || await speech.initialize()) {
        
        isListening.value = true;
        
        try {
          speech.listen(
            localeId: isLetterMode ? "en_US" : "id_ID",
            partialResults: true,
            cancelOnError: false,
            onResult: (val) {
              spokenText.value = val.recognizedWords;
              
              String target = isLetterMode ? currentItem['upper'] : currentWord['word'];
              target = target.toLowerCase();
              String spoken = val.recognizedWords.toLowerCase();

              // Deteksi dini super cepat
              bool isMatch = isWordMode 
                  ? spoken.contains(target) 
                  : _isLetterMatch(spoken, target);

              if (isMatch) {
                stopListening();
              } else if (val.hasConfidenceRating && val.confidence > 0) {
                // Jika sudah ada result final tapi masih salah, tetap selesaikan
                stopListening();
              }
            },
          );
        } catch (e) {
          print("Error speech listen: $e");
        }
      } else {
        Get.snackbar("Akses Mikrofon", "Mohon izinkan mikrofon untuk menggunakan fitur ini.");
      }
    } else {
      stopListening();
    }
  }

  void _verifyPronunciation() {
    String target = isLetterMode ? currentItem['upper'] : currentWord['word'];
    target = target.toLowerCase();
    String spoken = spokenText.value.toLowerCase().trim();

    if (spoken.isEmpty) return;

    bool isCorrect = isWordMode
        ? (spoken.contains(target) || target.contains(spoken))
        : _isLetterMatch(spoken, target);

    if (isCorrect) {
      _showSuccessDialog();
    } else {
      _showRetryDialog(spoken);
    }
  }

  void _showSuccessDialog() {
    // Advance progress
    if (isLetterMode) {
      Get.find<ProgressService>().completeSpellingLetter(currentIndex.value);
    } else {
      Get.find<ProgressService>().completeSpellingWord(currentIndex.value);
    }

    final pointService = Get.find<PointService>();
    bool isCombo = pointService.incrementCombo();
    
    String itemId = isLetterMode ? 'spell_letter_${currentItem['upper']}' : 'spell_word_${currentWord['word']}';
    int earned = pointService.completeActivity(itemId, isWord: isWordMode);
    
    if (isCombo) earned += 30; // Termasuk bonus combo untuk ditampilkan di animasi

    if (isCombo) {
      Get.find<SfxService>().playSuccess();
      Get.find<TtsService>().speak("Wah, luar biasa! Kamu benar 5 kali berturut-turut! Hebat banget!");
    } else {
      Get.find<SfxService>().playSuccess();
      Get.find<TtsService>().speak("Yey! Pintar sekali, pelafalanmu sudah pas!");
    }
    
    Get.defaultDialog(
      title: "🎉 LUAR BIASA! 🎉",
      titleStyle: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1CB0F6), fontSize: 24),
      content: Column(
        children: const [
          Icon(Icons.star_rounded, color: Colors.orange, size: 80),
          SizedBox(height: 10),
          Text("Pelafalanmu sempurna!", style: TextStyle(fontSize: 16)),
        ],
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1CB0F6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        onPressed: () {
          Get.back();
          PointAnimation.showPointAnimation(earned, onComplete: () {
            if (isCombo) {
              Get.snackbar(
                "COMBO MANTAP! 🔥",
                "5 benar berturut-turut! +30 Poin Bonus!",
                backgroundColor: Colors.orange,
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
                margin: const EdgeInsets.all(16),
              );
            }
            if (isLetterMode) nextItem(); else nextWord();
          });
        },
        child: const Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Text("LANJUT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      ),
    );
  }

  void _showRetryDialog(String spoken) {
    Get.find<PointService>().resetCombo(); // Reset combo jika salah
    Get.find<SfxService>().playWrong();
    Get.find<TtsService>().speak("Aduh, hampir benar. Coba lafalkan lagi lebih keras ya!");
    Get.defaultDialog(
      title: "Semangat! 💪",
      titleStyle: const TextStyle(fontWeight: FontWeight.w900, color: Colors.orange, fontSize: 24),
      content: Column(
        children: [
          const Icon(Icons.sentiment_satisfied_alt_rounded, color: Colors.orange, size: 80),
          const SizedBox(height: 10),
          Text("Kamu mengucapkan: '$spoken'", style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
          const Text("Coba lafalkan lebih jelas ya!", style: TextStyle(fontSize: 14)),
        ],
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        onPressed: () => Get.back(),
        child: const Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Text("COBA LAGI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      ),
    );
  }
}
