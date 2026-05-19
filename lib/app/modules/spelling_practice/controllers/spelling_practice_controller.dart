import 'package:get/get.dart';

class SpellingPracticeController extends GetxController {
  // =========================================================
  // INDEX
  // =========================================================

  final currentIndex = 0.obs;

  // =========================================================
  // TYPE
  // letter = latihan huruf
  // word = latihan eja kata
  // =========================================================

  late String type;

  // =========================================================
  // DATA HURUF
  // =========================================================

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

  // =========================================================
  // DATA KATA MUDAH
  // =========================================================

  final words = [
    {'word': 'BOLA', 'spell': 'BO • LA', 'sound': 'BO... LA... BOLA'},
    {'word': 'BUKU', 'spell': 'BU • KU', 'sound': 'BU... KU... BUKU'},
    {'word': 'MEJA', 'spell': 'ME • JA', 'sound': 'ME... JA... MEJA'},
    {'word': 'MOBIL', 'spell': 'MO • BIL', 'sound': 'MO... BIL... MOBIL'},
    {'word': 'KUCING', 'spell': 'KU • CING', 'sound': 'KU... CING... KUCING'},
  ];

  // =========================================================
  // INIT
  // =========================================================

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};

    type = args['type'] ?? 'letter';
  }

  // =========================================================
  // MODE
  // =========================================================

  bool get isLetterMode => type == 'letter';

  bool get isWordMode => type == 'word';

  // =========================================================
  // CURRENT ITEM
  // =========================================================

  dynamic get currentItem {
    if (isLetterMode) {
      return letters[currentIndex.value];
    }

    return words[currentIndex.value];
  }

  // =========================================================
  // TOTAL ITEM
  // =========================================================

  int get totalItem {
    if (isLetterMode) {
      return letters.length;
    }

    return words.length;
  }

  // =========================================================
  // CURRENT WORD
  // =========================================================

  Map<String, dynamic> get currentWord {
    return words[currentIndex.value];
  }

  // =========================================================
  // NEXT
  // =========================================================

  void nextItem() {
    if (currentIndex.value < totalItem - 1) {
      currentIndex.value++;
    }
  }

  void nextWord() {
    if (currentIndex.value < words.length - 1) {
      currentIndex.value++;
    }
  }

  // =========================================================
  // PREVIOUS
  // =========================================================

  void previousItem() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  void previousWord() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  // =========================================================
  // AUDIO HURUF
  // =========================================================

  void playSound() {
    if (isLetterMode) {
      Get.snackbar(
        "🔊 Audio Huruf",
        "Suara huruf ${currentItem['upper']} diputar",

        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "🔊 Audio Ejaan",
        "${currentItem['sound']}",

        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // =========================================================
  // AUDIO EJAAN
  // =========================================================

  void speakSpell() {
    final item = currentWord;

    Get.snackbar(
      "🔊 Ejaan Diputar",
      item['sound'],

      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // =========================================================
  // AUDIO KATA
  // =========================================================

  void speakWord() {
    final item = currentWord;

    Get.snackbar(
      "🔊 Kata Diputar",
      "Membaca kata ${item['word']}",

      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // =========================================================
  // AUDIO WORD
  // =========================================================

  void playWord() {
    Get.snackbar(
      "🔊 Audio Kata",
      "Kata ${currentItem['word']} diputar",

      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
