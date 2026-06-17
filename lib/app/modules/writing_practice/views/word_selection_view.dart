import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../../../routes/app_routes.dart';

class WordSelectionView extends StatelessWidget {
  const WordSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final words = [
      {'word': 'BOLA', 'emoji': '⚽', 'color': EduTheme.orange},
      {'word': 'BUKU', 'emoji': '📚', 'color': EduTheme.blue},
      {'word': 'MEJA', 'emoji': '🪑', 'color': EduTheme.primary},
      {'word': 'GIGI', 'emoji': '🦷', 'color': EduTheme.red},
      {'word': 'KUCING', 'emoji': '🐱', 'color': EduTheme.purple},
      {'word': 'MOBIL', 'emoji': '🚗', 'color': const Color(0xFF0096C7)},
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
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: words.length,
                itemBuilder: (context, index) {
                  final wordData = words[index];
                  final wordStr = wordData['word'] as String;
                  final emoji = wordData['emoji'] as String;
                  final color = wordData['color'] as Color;

                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.WORD_PRACTICE, arguments: {'word': wordStr});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(EduTheme.radiusLg),
                        boxShadow: EduTheme.softShadow(),
                        border: Border.all(color: color.withOpacity(0.3), width: 2),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(emoji, style: const TextStyle(fontSize: 32)),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              wordStr,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: color,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_rounded, color: color.withOpacity(0.5)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
