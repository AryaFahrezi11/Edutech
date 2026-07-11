import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../../../routes/app_routes.dart';
import '../../../services/progress_service.dart';

class WordSelectionView extends StatelessWidget {
  const WordSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final missionIndex = Get.arguments?['mission_index'] as int?;

    final words = [
      {'word': 'KURSI', 'emoji': '🪑', 'color': EduTheme.orange},
      {'word': 'BOTOL', 'emoji': '🍶', 'color': EduTheme.blue},
      {'word': 'BUKU', 'emoji': '📚', 'color': EduTheme.primary},
      {'word': 'GELAS', 'emoji': '🥤', 'color': EduTheme.red},
      {'word': 'TAS', 'emoji': '🎒', 'color': EduTheme.purple},
      {'word': 'JAM', 'emoji': '🕐', 'color': const Color(0xFF0096C7)},
      {'word': 'LAPTOP', 'emoji': '💻', 'color': EduTheme.orange},
      {'word': 'GUNTING', 'emoji': '✂️', 'color': EduTheme.blue},
      {'word': 'MEJA', 'emoji': '🍽️', 'color': EduTheme.primary},
      {'word': 'HANDPHONE', 'emoji': '📱', 'color': EduTheme.purple},
    ];

    return Scaffold(
      backgroundColor: EduTheme.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER ──
            Container(
              padding: const EdgeInsets.fromLTRB(8, 12, 20, 20),
              decoration: EduTheme.headerDecoration(gradient: EduTheme.primaryGradient),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        onPressed: () => Get.back(),
                      ),
                      const Expanded(
                        child: Text(
                          "Pilih Kata",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── LIST KATA ──
            Expanded(
              child: Obx(() {
                final progress = Get.find<ProgressService>().unlockedWritingWord.value;
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    final wordData = words[index];
                    final wordStr = wordData['word'] as String;
                    final emoji = wordData['emoji'] as String;
                    final color = wordData['color'] as Color;
                    final isLocked = index > progress;

                    return GestureDetector(
                      onTap: isLocked ? () {
                        Get.snackbar(
                          "Terkunci 🔒", 
                          "Selesaikan kata sebelumnya terlebih dahulu!",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.orange.withOpacity(0.9),
                          colorText: Colors.white,
                          borderRadius: 20,
                          margin: const EdgeInsets.all(16),
                        );
                      } : () {
                        Get.toNamed(Routes.WORD_PRACTICE, arguments: {
                          'word': wordStr,
                          'index': index,
                          'mission_index': missionIndex,
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isLocked ? Colors.grey.shade200 : Colors.white,
                          borderRadius: BorderRadius.circular(EduTheme.radiusLg),
                          boxShadow: isLocked ? [] : EduTheme.softShadow(),
                          border: Border.all(color: isLocked ? Colors.transparent : color.withOpacity(0.3), width: 2),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: isLocked ? Colors.grey.shade300 : color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(isLocked ? "🔒" : emoji, style: const TextStyle(fontSize: 32)),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                isLocked ? "???" : wordStr,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: isLocked ? Colors.grey.shade400 : color,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            if (!isLocked)
                              Icon(Icons.arrow_forward_ios_rounded, color: color.withOpacity(0.5)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
