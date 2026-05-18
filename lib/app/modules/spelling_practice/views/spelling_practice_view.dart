import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/spelling_practice_controller.dart';

class SpellingPracticeView extends GetView<SpellingPracticeController> {
  const SpellingPracticeView({super.key});

  @override
  Widget build(BuildContext context) {
    final letters = [
      {'upper': 'A', 'lower': 'a'},
      {'upper': 'B', 'lower': 'b'},
      {'upper': 'C', 'lower': 'c'},
      {'upper': 'D', 'lower': 'd'},
      {'upper': 'E', 'lower': 'e'},
      {'upper': 'F', 'lower': 'f'},
      {'upper': 'G', 'lower': 'g'},
    ];
    final currentIndex = 0.obs;

    // TAMBAHKAN INI
    final PageController pageController = PageController();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EC),

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            const SizedBox(height: 12),

            Expanded(
              child: Stack(
                children: [
                  // PAGE VIEW
                  PageView.builder(
                    controller: pageController,

                    // NONAKTIFKAN GESER MANUAL
                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: letters.length,

                    onPageChanged: (index) {
                      currentIndex.value = index;
                    },

                    itemBuilder: (context, index) {
                      final item = letters[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),

                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(32),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.12),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),

                          child: Stack(
                            children: [
                              CustomPaint(
                                painter: _SpellingBackgroundPainter(),
                                child: const SizedBox.expand(),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(22),

                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20),

                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFFF9800),
                                            Color(0xFFFFC107),
                                          ],
                                        ),

                                        borderRadius: BorderRadius.circular(24),
                                      ),

                                      child: Column(
                                        children: [
                                          const Text(
                                            "🔤",
                                            style: TextStyle(fontSize: 55),
                                          ),

                                          const SizedBox(height: 12),

                                          Text(
                                            "Huruf ${item['upper']}",
                                            style: const TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
                                          ),

                                          const SizedBox(height: 6),

                                          const Text(
                                            "Tekan huruf untuk mendengar suara",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const Spacer(),

                                    _buildLetterCard(
                                      upperLetter: item['upper']!,
                                      lowerLetter: item['lower']!,
                                    ),

                                    const Spacer(),

                                    SizedBox(
                                      width: double.infinity,
                                      height: 56,

                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Get.snackbar(
                                            "🔊 Audio Diputar",
                                            "Suara huruf ${item['upper']} diputar ulang",
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.orange,
                                            colorText: Colors.white,
                                          );
                                        },

                                        icon: const Icon(
                                          Icons.volume_up_rounded,
                                        ),

                                        label: const Text(
                                          "ULANGI SUARA",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),

                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: const Color(
                                            0xFFFF9800,
                                          ),

                                          foregroundColor: Colors.white,

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    Obx(
                                      () => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,

                                        children: List.generate(
                                          letters.length,
                                          (dotIndex) {
                                            final active =
                                                currentIndex.value == dotIndex;

                                            return AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),

                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 4,
                                                  ),

                                              width: active ? 22 : 8,
                                              height: 8,

                                              decoration: BoxDecoration(
                                                color: active
                                                    ? Colors.orange
                                                    : Colors.orange.withOpacity(
                                                        0.3,
                                                      ),

                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // TOMBOL KIRI
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,

                    child: Center(
                      child: Obx(() {
                        final isFirst = currentIndex.value == 0;

                        return GestureDetector(
                          onTap: isFirst
                              ? null
                              : () {
                                  pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },

                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: isFirst ? 0.4 : 1,

                            child: Container(
                              width: 52,
                              height: 52,

                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),

                              child: const Icon(
                                Icons.chevron_left_rounded,
                                size: 34,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // TOMBOL KANAN
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,

                    child: Center(
                      child: Obx(() {
                        final isLast = currentIndex.value == letters.length - 1;

                        return GestureDetector(
                          onTap: isLast
                              ? null
                              : () {
                                  pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },

                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: isLast ? 0.4 : 1,

                            child: Container(
                              width: 52,
                              height: 52,

                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),

                              child: const Icon(
                                Icons.chevron_right_rounded,
                                size: 34,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  // ───────────────── HEADER ─────────────────
  // ───────────────── HEADER ─────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 14, 12, 16),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFFC107)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),

      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),

            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,

              children: const [
                Text(
                  "🔤 Latihan Mengeja",
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  "Belajar huruf A - Z",
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── CARD HURUF ─────────────────
  Widget _buildLetterCard({
    required String upperLetter,
    required String lowerLetter,
  }) {
    return GestureDetector(
      onTap: () {
        Get.snackbar(
          "🔊 Audio Huruf",
          "Suara huruf $upperLetter diputar",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      },

      child: Container(
        height: 300,
        width: double.infinity,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),

          border: Border.all(color: Colors.orange.withOpacity(0.15), width: 2),

          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Stack(
          children: [
            // ICON SUARA
            Positioned(
              top: 18,
              right: 18,

              child: Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),

                child: Icon(
                  Icons.volume_up_rounded,
                  color: Colors.orange.shade400,
                  size: 28,
                ),
              ),
            ),

            // HURUF BESAR
            Center(
              child: Text(
                upperLetter,

                style: const TextStyle(
                  fontSize: 170,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFE65100),
                ),
              ),
            ),

            // HURUF KECIL
            Positioned(
              right: 28,
              bottom: 24,

              child: Text(
                lowerLetter,

                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────── BACKGROUND PAINTER ─────────────────
class _SpellingBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..strokeWidth = 2;

    const spacing = 40.0;

    for (double y = spacing; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
