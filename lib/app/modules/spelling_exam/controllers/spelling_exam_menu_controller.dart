import 'package:get/get.dart';
import '../../../services/progress_service.dart';
import '../../../routes/app_routes.dart';
import 'spelling_exam_controller.dart';

import '../../../services/tts_service.dart';
import 'package:flutter/material.dart';

class SpellingExamMenuController extends GetxController {
  final ProgressService progressService = Get.find<ProgressService>();
  final ScrollController scrollController = ScrollController();
  final category = 'capital'.obs;
  int? missionIndex;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['category'] != null) {
      category.value = Get.arguments['category'];
    }
    if (Get.arguments != null && Get.arguments['mission_index'] != null) {
      missionIndex = Get.arguments['mission_index'];
    }

    final tts = Get.find<TtsService>();
    if (category.value == 'word') {
      tts.speak("Sekarang kita akan memulai ujian mengeja kata");
    } else {
      tts.speak("Sekarang kita akan memulai ujian mengeja huruf");
    }
    
    // Auto-scroll ke posisi node terakhir yang terbuka saat peta misi pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        // Asumsi tinggi tiap node + padding sekitar 130 pixels
        // Karena list di-reverse, indeks ke-0 ada di bawah
        double offset = (unlockedIndex * 130.0) - (Get.height / 3);
        if (offset < 0) offset = 0;
        scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  int get unlockedIndex {
    if (category.value == 'word') {
      return progressService.unlockedSpellingExamWord.value;
    } else {
      return progressService.unlockedSpellingExamLetter.value;
    }
  }

  void openLevel(int index) async {
    if (index > unlockedIndex) {
      Get.snackbar(
        'Level Terkunci! 🔒',
        'Selesaikan level sebelumnya dulu ya!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.primaryColor.withOpacity(0.8),
        colorText: Get.theme.colorScheme.onPrimary,
      );
      return;
    }

    final result = await Get.toNamed(Routes.SPELLING_EXAM, arguments: {
      'index': index,
      'category': category.value,
      'title': category.value == 'capital' ? 'Huruf Kapital' : (category.value == 'word' ? 'Kata Mudah' : 'Huruf Kecil'),
      'mission_index': missionIndex,
    });

    if (result == true) {
      final nextIndex = index + 1;
      await Future.delayed(const Duration(milliseconds: 1500));
      final bank = SpellingExamController.getQuestionBank(category.value);
      if (nextIndex < bank.length) {
        openLevel(nextIndex);
      }
    }
  }
}
