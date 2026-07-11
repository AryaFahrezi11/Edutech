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
  int? missionIndex;

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
    {'word': 'KURSI', 'spell': 'KUR • SI', 'sound': 'KUR... SI... KURSI', 'icon': '🪑'},
    {'word': 'BOTOL', 'spell': 'BO • TOL', 'sound': 'BO... TOL... BOTOL', 'icon': '🍶'},
    {'word': 'BUKU', 'spell': 'BU • KU', 'sound': 'BU... KU... BUKU', 'icon': '📚'},
    {'word': 'GELAS', 'spell': 'GE • LAS', 'sound': 'GE... LAS... GELAS', 'icon': '🥤'},
    {'word': 'TAS', 'spell': 'TAS', 'sound': 'TAS... TAS', 'icon': '🎒'},
    {'word': 'JAM', 'spell': 'JAM', 'sound': 'JAM... JAM', 'icon': '🕐'},
    {'word': 'LAPTOP', 'spell': 'LAP • TOP', 'sound': 'LAP... TOP... LAPTOP', 'icon': '💻'},
    {'word': 'GUNTING', 'spell': 'GUN • TING', 'sound': 'GUN... TING... GUNTING', 'icon': '✂️'},
    {'word': 'MEJA', 'spell': 'ME • JA', 'sound': 'ME... JA... MEJA', 'icon': '🍽️'},
    {'word': 'HANDPHONE', 'spell': 'HAND • PHONE', 'sound': 'HAND... PHONE... HANDPHONE', 'icon': '📱'},
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    type = args['type'] ?? 'letter';
    if (args['index'] != null) {
      currentIndex.value = args['index'];
    }
    if (args['mission_index'] != null) {
      missionIndex = args['mission_index'];
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
  // Strategi: gunakan id_ID locale + minta anak bilang "huruf A"
  // sehingga engine punya cukup audio untuk dikenali
  bool _isLetterMatch(String spoken, String target) {
    if (spoken.isEmpty) return false;
    
    // Normalisasi: hilangkan tanda baca dan trim
    spoken = spoken.replaceAll(RegExp(r'[^a-z0-9\s]'), '').trim();
    var words = spoken.split(' ');
    
    // 1. Cek exact match langsung
    if (words.contains(target) || spoken == target) return true;
    
    // 2. Cek pola "huruf X" — karena kita minta anak bilang "huruf A"
    if (spoken.contains('huruf $target') || spoken.contains('huruf ${target.toUpperCase()}')) return true;
    
    // 3. Alias pengucapan fonetik Indonesia (cara anak-anak menyebutkan huruf)
    // Diperluas dengan variasi STT yang sering muncul di id_ID dan en_US
    final Map<String, List<String>> aliases = {
      'a': ['ah', 'aa', 'ha', 'a', 'huruf a', 'uh', 'ar'],
      'b': ['be', 'beh', 'bee', 'bi', 'b', 'bay', 'bae', 'huruf b', 'huruf be', 'pe'],
      'c': ['ce', 'ceh', 'ci', 'c', 'se', 'she', 'si', 'huruf c', 'huruf ce', 'see'],
      'd': ['de', 'deh', 'di', 'd', 'the', 'dee', 'huruf d', 'huruf de'],
      'e': ['eh', 'ee', 'e', 'i', 'hey', 'ye', 'huruf e'],
      'f': ['ef', 'ep', 'ev', 'f', 'eff', 'huruf f', 'huruf ef', 'ef'],
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
        // 3a. Cek per kata
        if (words.contains(alias)) return true;
        // 3b. Cek apakah alias muncul sebagai substring dalam spoken text
        //     Ini penting karena STT kadang menggabungkan kata tanpa spasi
        if (alias.length >= 2 && spoken.contains(alias)) return true;
      }
    }
    
    // 4. Fallback: cek huruf pertama dari ucapan
    //    Misal anak bilang "a" tapi STT menerjemahkan jadi "ah" atau "am"
    if (spoken.isNotEmpty && spoken[0] == target && spoken.length <= 3) return true;
    
    return false;
  }

  // =========================================================
  // SPEECH-TO-TEXT (MIKROFON ANAK)
  // =========================================================
  void listen() async {
    if (!isListening.value) {
      if (speech.isAvailable || await speech.initialize()) {
        
        isListening.value = true;
        
        // Beri instruksi suara ke anak: "Coba bilang: huruf A"
        if (isLetterMode) {
          Get.find<TtsService>().speak("Coba bilang: huruf ${currentItem['upper']}");
          await Future.delayed(const Duration(milliseconds: 1500));
        }
        
        try {
          speech.listen(
            // Gunakan id_ID untuk semua mode karena anak-anak Indonesia
            localeId: "id_ID",
            partialResults: true,
            cancelOnError: false,
            // Beri waktu lebih lama agar engine punya cukup audio
            listenFor: const Duration(seconds: 8),
            pauseFor: const Duration(seconds: 3),
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
              } else if (val.finalResult && spoken.isNotEmpty) {
                // Hanya selesaikan jika ini BENAR-BENAR final result
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
      if (missionIndex != null && Get.find<ProgressService>().unlockedSpellingLetter.value >= 5) {
        Get.find<ProgressService>().completeMissionNode(missionIndex!);
      }
    } else {
      Get.find<ProgressService>().completeSpellingWord(currentIndex.value);
      if (missionIndex != null && Get.find<ProgressService>().unlockedSpellingWord.value >= 5) {
        Get.find<ProgressService>().completeMissionNode(missionIndex!);
      }
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
