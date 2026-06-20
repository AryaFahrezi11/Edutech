import 'package:get/get.dart';

class ProgressService extends GetxService {
  // Index maksimal yang sudah terbuka untuk masing-masing kategori latihan
  // 0 artinya hanya item pertama (index 0) yang terbuka.
  
  var unlockedWritingLetter = 0.obs;
  var unlockedWritingWord = 0.obs;
  var unlockedSpellingLetter = 0.obs;
  var unlockedSpellingWord = 0.obs;

  // Method untuk menyelesaikan suatu level dan membuka kunci level berikutnya
  void completeWritingLetter(int currentIndex) {
    if (currentIndex >= unlockedWritingLetter.value) {
      unlockedWritingLetter.value = currentIndex + 1;
    }
  }

  void completeWritingWord(int currentIndex) {
    if (currentIndex >= unlockedWritingWord.value) {
      unlockedWritingWord.value = currentIndex + 1;
    }
  }

  void completeSpellingLetter(int currentIndex) {
    if (currentIndex >= unlockedSpellingLetter.value) {
      unlockedSpellingLetter.value = currentIndex + 1;
    }
  }

  void completeSpellingWord(int currentIndex) {
    if (currentIndex >= unlockedSpellingWord.value) {
      unlockedSpellingWord.value = currentIndex + 1;
    }
  }
}
