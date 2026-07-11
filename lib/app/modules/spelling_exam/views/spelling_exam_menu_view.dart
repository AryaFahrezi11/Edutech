import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:lottie/lottie.dart';
import '../controllers/spelling_exam_menu_controller.dart';
import '../controllers/spelling_exam_controller.dart';

class SpellingExamMenuView extends GetView<SpellingExamMenuController> {
  const SpellingExamMenuView({super.key});

  static const _textDark = Color(0xFF3A2F6B);

  Map<String, dynamic> _getTheme(String category) {
    if (category == 'lowercase') {
      return {
        'gradient': const [Color(0xFFF2994A), Color(0xFFF2C94C), Color(0xFFFFF8E1)],
        'primary': const Color(0xFFFF9800),
        'shadow': const Color(0xFFF57C00),
        'emojis': ["☀️", "🐪", "🌵", "🏜️", "✨"],
      };
    } else if (category == 'word') {
      return {
        'gradient': const [Color(0xFF00C9FF), Color(0xFF92FE9D), Color(0xFFE0F7FA)],
        'primary': const Color(0xFF00BCD4),
        'shadow': const Color(0xFF0097A7),
        'emojis': ["🌊", "🐠", "🦀", "🐳", "🫧"],
      };
    } else {
      return {
        'gradient': const [Color(0xFF56AB2F), Color(0xFFA8E063), Color(0xFFE8F5E9)],
        'primary': const Color(0xFF4CAF50),
        'shadow': const Color(0xFF2E7D32),
        'emojis': ["🌳", "🌿", "🦜", "🐛", "🌻"],
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
                ? 'Mengeja Huruf'
                : controller.category.value == 'lowercase'
                    ? 'Mengeja Huruf Kecil'
                    : 'Mengeja Kata',
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
                ..._buildStaticDecorations(theme),
              
              Obx(() {
                final List<String> items = [];
                if (controller.category.value == 'word') {
                  final bank = SpellingExamController.getQuestionBank('word');
                  items.addAll(bank.map((q) => q['answer'] as String));
                } else {
                  for (int i = 0; i < 26; i++) {
                    String char = String.fromCharCode(65 + i);
                    if (controller.category.value == 'lowercase') {
                      char = char.toLowerCase();
                    }
                    items.add(char);
                  }
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  reverse: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
              final letter = items[index];
              final isUnlocked = index <= controller.unlockedIndex;
              final isCurrent = index == controller.unlockedIndex;
              
              final double offset = math.sin(index * 0.8) * 100;

              String? lottieAsset;
              if (index % 4 == 2) {
                final lotties = ['bee.json', 'paw-prints.json', 'cute-cat.json', 'dog.json', 'owl.json', 'rabbit.json'];
                lottieAsset = 'assets/lotties/${lotties[(index ~/ 4) % lotties.length]}';
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    if (lottieAsset != null && lottieAsset != 'assets/lotties/paw-prints.json')
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
                          width: 250,
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
                        fontSize: isWord ? 14 : 32,
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
          if (isCurrent)
            Positioned(
              top: -30,
              child: _buildBouncingArrow(),
            ),
        ],
      ),
    );
  }

  Widget _buildBouncingArrow() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 10),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value > 5 ? 10 - value : value),
          child: child,
        );
      },
      onEnd: () {
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.yellow.shade700,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          "Mulai",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStaticDecorations(Map<String, dynamic> theme) {
    final emojis = theme['emojis'] as List<String>;
    final random = math.Random(42); 

    return List.generate(15, (index) {
      final emoji = emojis[random.nextInt(emojis.length)];
      final top = random.nextDouble() * Get.height;
      final left = random.nextDouble() * Get.width;
      final size = 20.0 + random.nextDouble() * 30.0;
      final opacity = 0.1 + random.nextDouble() * 0.3;

      return Positioned(
        top: top,
        left: left,
        child: Opacity(
          opacity: opacity,
          child: Text(
            emoji,
            style: TextStyle(fontSize: size),
          ),
        ),
      );
    });
  }
}
