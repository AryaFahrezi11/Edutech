import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/multiplayer_battle_controller.dart';

class MultiplayerBattleView extends GetView<MultiplayerBattleController> {
  const MultiplayerBattleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF), // Terang
      body: SafeArea(
        child: Column(
          children: [
            _buildPKBar(),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildPlayerArea(
                      player: controller.player1,
                      name: controller.player1Name,
                      color: const Color(0xFFFF416C),
                      isLeft: true,
                    ),
                  ),
                  Container(
                    width: 6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey.shade300, Colors.grey.shade400],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ), // Divider
                  Expanded(
                    child: _buildPlayerArea(
                      player: controller.player2,
                      name: controller.player2Name,
                      color: const Color(0xFF00C9FF),
                      isLeft: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPKBar() {
    return Container(
      height: 70,
      width: double.infinity,
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          return Stack(
            alignment: Alignment.center,
            children: [
              // Background Bar (The PK Tug of War)
              Obx(() {
                return Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.elasticOut,
                      width: maxWidth * controller.pkRatio.value,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFFFF4B2B), Color(0xFFFF416C)]),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.elasticOut,
                      width: maxWidth * (1.0 - controller.pkRatio.value),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)]),
                      ),
                    ),
                  ],
                );
              }),

              // Pulse animation for the clash line
              Obx(() {
                double scale = 1.0 + 0.05 * sin(controller.timeLeft.value * pi);
                return Positioned(
                  left: (maxWidth * controller.pkRatio.value) - 20,
                  child: Transform.scale(
                    scale: scale,
                    child: const Icon(Icons.flash_on, color: Colors.yellowAccent, size: 40, shadows: [Shadow(color: Colors.black45, blurRadius: 10)]),
                  ),
                );
              }),

              // Names on Bar
              Positioned(
                left: 20,
                child: SizedBox(
                  width: maxWidth * 0.3,
                  child: Text(
                    controller.player1Name, 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, shadows: [Shadow(color: Colors.black45, blurRadius: 8)]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Positioned(
                right: 20,
                child: SizedBox(
                  width: maxWidth * 0.3,
                  child: Text(
                    controller.player2Name, 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, shadows: [Shadow(color: Colors.black45, blurRadius: 8)]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              
              // Timer in Center
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutBack,
                builder: (context, val, child) {
                  return Transform.scale(scale: val, child: child);
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFFD166), width: 4),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 5))],
                  ),
                  child: Center(
                    child: Obx(() => Text(
                      "${controller.timeLeft.value}",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: controller.timeLeft.value <= 10 ? Colors.redAccent : const Color(0xFF2C3E50),
                      ),
                    )),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlayerArea({
    required PlayerState player,
    required String name,
    required Color color,
    required bool isLeft,
  }) {
    return Obx(() {
      if (!controller.isGameRunning.value && !controller.isGameOver.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.isGameOver.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("SKOR AKHIR", style: TextStyle(fontSize: 24, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
              Text("${player.score.value}", style: TextStyle(fontSize: 80, color: color, fontWeight: FontWeight.w900)),
            ],
          )
        );
      }

      int cIndex = player.currentChallengeIndex.value;
      List<PKChallenge> challenges = isLeft ? controller.p1Challenges : controller.p2Challenges;
      PKChallenge currentChallenge = challenges[cIndex];

      return Container(
        color: isLeft ? Colors.red.withValues(alpha: 0.02) : Colors.blue.withValues(alpha: 0.02),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji Target with float animation
            Flexible(
              flex: 2,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(seconds: 1),
                builder: (ctx, val, child) {
                  return Transform.translate(
                    offset: Offset(0, 5 * sin(val * 2 * pi)),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(currentChallenge.emoji, style: const TextStyle(fontSize: 80)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            
            // Filled Boxes with Shake Animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: player.isShaking.value ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 400),
              builder: (context, value, child) {
                // Shake offset
                double offset = sin(value * pi * 4) * 10;
                return Transform.translate(
                  offset: Offset(offset, 0),
                  child: child,
                );
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(player.filledLetters.length, (index) {
                    String letter = player.filledLetters[index];
                    bool isFilled = letter.isNotEmpty;
                    bool isError = player.isShaking.value;
                    
                    return GestureDetector(
                      onTap: () => controller.onFilledLetterTap(player, index),
                      child: Container(
                        width: 50,
                        height: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isFilled ? (isError ? Colors.redAccent : color) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isFilled ? (isError ? Colors.red : color) : Colors.grey.shade300, 
                            width: 2
                          ),
                          boxShadow: isFilled ? [
                            BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 3))
                          ] : [],
                        ),
                        child: Center(
                          child: Text(
                            letter,
                            style: TextStyle(
                              fontSize: 30, 
                              fontWeight: FontWeight.w900, 
                              color: isFilled ? Colors.white : Colors.transparent
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Scrambled Letters (Tap to pick)
            Flexible(
              flex: 3,
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: List.generate(player.scrambledLetters.length, (index) {
                    String letter = player.scrambledLetters[index];
                    if (letter.isEmpty) {
                      return const SizedBox(width: 55, height: 55); // Placeholder
                    }
                    
                    return GestureDetector(
                      onTap: () => controller.onScrambledLetterTap(player, challenges, index),
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 6, offset: const Offset(0, 4))
                          ],
                          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
                        ),
                        child: Center(
                          child: Text(
                            letter,
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: color),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
