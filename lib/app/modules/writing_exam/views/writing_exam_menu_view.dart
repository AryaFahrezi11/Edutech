import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:lottie/lottie.dart';
import '../controllers/writing_exam_menu_controller.dart';
import '../controllers/writing_exam_controller.dart';

class WritingExamMenuView extends GetView<WritingExamMenuController> {
  const WritingExamMenuView({Key? key}) : super(key: key);

  static const _bgLight = Color(0xFFF0F7FF);
  static const _textDark = Color(0xFF3A2F6B);

  // Helper untuk mendapatkan tema berdasarkan kategori
  Map<String, dynamic> _getTheme(String category) {
    if (category == 'lowercase') {
      // Tema Senja (Sunset) untuk huruf kecil
      return {
        'gradient': const [Color(0xFFFF9A9E), Color(0xFFFECFEF), Color(0xFFFFF1EB)],
        'primary': const Color(0xFFFF6B6B),
        'shadow': const Color(0xFFCC5555),
        'emojis': ["🌸", "☁️", "✨", "🌺", "⭐"],
      };
    } else if (category == 'word') {
      // Tema Malam/Luar Angkasa untuk kata
      return {
        'gradient': const [Color(0xFF2B5876), Color(0xFF4E4376), Color(0xFF152336)],
        'primary': const Color(0xFF9D4EDD),
        'shadow': const Color(0xFF5A189A),
        'emojis': ["⭐", "🌙", "🚀", "✨", "🪐"],
      };
    } else {
      // Tema Siang (Siang Terang) untuk huruf kapital (Default)
      return {
        'gradient': const [Color(0xFF87CEEB), Color(0xFFB3E5FC), Color(0xFFE8F5E9)],
        'primary': const Color(0xFF1CB0F6),
        'shadow': const Color(0xFF1480B0),
        'emojis': ["☁️", "⭐", "📝", "🖍️", "✨", "✏️"],
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = _getTheme(controller.category.value);
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            controller.category.value == 'capital'
                ? 'Huruf Kapital'
                : controller.category.value == 'lowercase'
                    ? 'Huruf Kecil'
                    : 'Menulis Kata',
            style: const TextStyle(fontWeight: FontWeight.w900, color: _textDark),
          ),
          centerTitle: true,
          backgroundColor: Colors.white.withOpacity(0.9),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _textDark),
            onPressed: () => Get.back(),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: theme['gradient'] as List<Color>,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Static background decorations
                ..._buildStaticDecorations(theme),
              
              Obx(() {
                // Buat list 26 huruf (A-Z)
                final List<String> letters = [];
                if (controller.category.value == 'word') {
                  final bank = WritingExamController.questionBank['word'] ?? [];
                  letters.addAll(bank.map((q) => q['letter'] as String));
                } else {
                  for (int i = 0; i < 26; i++) {
                    String char = String.fromCharCode(65 + i); // A, B, C...
                    if (controller.category.value == 'lowercase') {
                      char = char.toLowerCase();
                    }
                    letters.add(char);
                  }
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  // Reverse list agar mulai dari Bawah ke Atas (seperti game map)
                  reverse: true,
                  itemCount: letters.length,
                  itemBuilder: (context, index) {
              final letter = letters[index];
              final isUnlocked = index <= controller.unlockedIndex;
              final isCurrent = index == controller.unlockedIndex;
              
              // Hitung posisi horizontal meliuk-liuk (Snake Path) menggunakan sin wave
              // Index 0 -> tengah, 1 -> kanan, 2 -> tengah, 3 -> kiri, dst.
              // Kita gunakan faktor sin agar meliuk halus.
              final double offset = math.sin(index * 0.8) * 100;

              // Tentukan animasi lottie acak untuk lekukan maksimal (puncak sin wave)
              String? lottieAsset;
              // sin(index * 0.8) mencapai puncak (lekukan maksimal) kira-kira di index 2, 6, 10, 14, 18, 22...
              // yaitu saat index % 4 == 2
              if (index % 4 == 2) {
                final lotties = ['bee.json', 'pencil.json', 'cute-cat.json', 'dog.json', 'owl.json', 'rabbit.json'];
                lottieAsset = 'assets/lotties/${lotties[(index ~/ 4) % lotties.length]}';
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Lottie diletakkan di sisi berlawanan dari posisi node agar seimbang
                    if (lottieAsset != null)
                      Positioned(
                        left: offset > 0 ? 100 : null,
                        right: offset < 0 ? 100 : null,
                        child: Opacity(
                          opacity: 0.8,
                          child: Lottie.asset(lottieAsset, width: 100, height: 100),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 250, // Batasi area liukan agar rapat dan rapi
                          child: Transform.translate(
                            offset: Offset(offset, 0),
                            child: Align(
                              alignment: Alignment.center,
                              child: _buildLevelNode(
                                letter: letter,
                                index: index,
                                isUnlocked: isUnlocked,
                                isCurrent: isCurrent,
                                theme: theme,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ],
    ),
  ),
),
);
});
}

  Widget _buildLevelNode({
    required String letter,
    required int index,
    required bool isUnlocked,
    required bool isCurrent,
    required Map<String, dynamic> theme,
  }) {
    final bgColor = isUnlocked ? theme['primary'] as Color : Colors.grey.shade300;
    final shadowColor = isUnlocked ? theme['shadow'] as Color : Colors.grey.shade400;
    final textColor = isUnlocked ? Colors.white : Colors.grey.shade500;
    final isWord = letter.length > 1;

    return GestureDetector(
      onTap: () => controller.openLevel(index),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Lingkaran utama
          Container(
            width: isWord ? 85 : 70,
            height: isWord ? 85 : 70,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  offset: const Offset(0, 6),
                ),
                if (isCurrent)
                  BoxShadow(
                    color: (theme['primary'] as Color).withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 5,
                  )
              ],
              border: isCurrent ? Border.all(color: Colors.white, width: 3) : null,
            ),
            child: Center(
              child: isUnlocked
                  ? Text(
                      letter,
                      style: TextStyle(
                        fontSize: isWord ? 16 : 32,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    )
                  : const Icon(
                      Icons.lock_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
            ),
          ),

          // Mahkota bintang jika sudah lewat
          if (isUnlocked && !isCurrent)
            Positioned(
              top: -10,
              right: -5,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
            
          // Indikator panah "mainkan ini"
          if (isCurrent)
            Positioned(
              left: -30,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 10),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                builder: (context, val, child) {
                  return Transform.translate(
                    offset: Offset(val, 0),
                    child: Icon(
                      Icons.arrow_right_rounded,
                      color: theme['primary'] as Color,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildStaticDecorations(Map<String, dynamic> theme) {
    final decorations = <Widget>[];
    final random = math.Random(123);
    final emojis = theme['emojis'] as List<String>;

    for (int i = 0; i < 15; i++) {
      final yPos = random.nextDouble() * 800; // Asumsi tinggi layar 800
      final xPos = random.nextDouble() * 400; // Asumsi lebar layar 400
      final emoji = emojis[random.nextInt(emojis.length)];
      final size = 16.0 + random.nextDouble() * 14;

      decorations.add(
        Positioned(
          left: xPos,
          top: yPos,
          child: Opacity(
            opacity: 0.2 + random.nextDouble() * 0.2,
            child: Text(emoji, style: TextStyle(fontSize: size)),
          ),
        ),
      );
    }
    return decorations;
  }
}
