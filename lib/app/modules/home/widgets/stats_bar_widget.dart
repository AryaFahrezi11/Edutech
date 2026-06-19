import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home_controller.dart';

/// Compact stats bar di bagian atas mission map.
/// Menampilkan XP, streak, level, dan progress bar.
class StatsBarWidget extends StatelessWidget {
  const StatsBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // XP / Stars
          _StatItem(
            emoji: "⭐",
            value: "${controller.totalXP.value}",
            label: "Bintang",
            color: const Color(0xFFFFB703),
          ),

          // Divider vertikal
          Container(
            height: 36,
            width: 1.5,
            color: const Color(0xFFE5E7EB),
          ),

          // Streak
          _StatItem(
            emoji: "🔥",
            value: "${controller.streakDays.value}",
            label: "Hari",
            color: const Color(0xFFFF6B35),
          ),

          // Divider vertikal
          Container(
            height: 36,
            width: 1.5,
            color: const Color(0xFFE5E7EB),
          ),

          // Level
          _StatItem(
            emoji: "🏅",
            value: "Lv.${controller.currentLevel.value}",
            label: "Level",
            color: const Color(0xFF6C63FF),
          ),

          // Divider vertikal
          Container(
            height: 36,
            width: 1.5,
            color: const Color(0xFFE5E7EB),
          ),

          // Progress
          _ProgressItem(
            completed: controller.completedMissions.length,
            total: controller.missionNodes.length,
          ),
        ],
      )),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final int completed;
  final int total;

  const _ProgressItem({
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? completed / total : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 36,
          height: 36,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 4,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1CB0F6)),
              ),
              Text(
                "${(progress * 100).toInt()}%",
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1CB0F6),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          "Progres",
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }
}
