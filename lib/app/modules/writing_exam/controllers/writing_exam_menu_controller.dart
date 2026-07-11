import 'package:get/get.dart';
import '../../../services/progress_service.dart';
import '../../../routes/app_routes.dart';
import 'writing_exam_controller.dart';

import 'package:flutter/material.dart';

class WritingExamMenuController extends GetxController {
  final ProgressService progressService = Get.find<ProgressService>();
  final ScrollController scrollController = ScrollController();
  
  // Kategori apa yang sedang dibuka (misal: 'capital' atau 'lowercase')
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

  // Mendapatkan index level tertinggi yang sudah terbuka untuk kategori ini
  int get unlockedIndex {
    if (category.value == 'capital') {
      return progressService.unlockedWritingLetter.value;
    } else if (category.value == 'lowercase') {
      return progressService.unlockedWritingLowercase.value;
    } else {
      return progressService.unlockedWritingWord.value;
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

    // Pindah ke kanvas menggambar dengan membawa indeks level dan kategori
    final result = await Get.toNamed(Routes.WRITING_EXAM, arguments: {
      'index': index,
      'category': category.value,
      'title': category.value == 'capital' ? 'Huruf Kapital' : 'Huruf Kecil',
      'mission_index': missionIndex,
    });

    if (result == true) {
      final nextIndex = index + 1;
      // Beri jeda 1.5 detik agar anak bisa melihat lock terbuka (karena unlockedIndex otomatis update dari progressService)
      await Future.delayed(const Duration(milliseconds: 1500));
      final bank = WritingExamController.questionBank[category.value] ?? [];
      if (nextIndex < bank.length) {
        openLevel(nextIndex);
      }
    }
  }
}
