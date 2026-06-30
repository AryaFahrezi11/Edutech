import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/mission_node.dart';
import '/app/services/progress_service.dart';
import '/app/services/point_service.dart';

class HomeController extends GetxController {
  var tabIndex = 0.obs; // Untuk navigasi bawah

  // === GAMIFICATION STATE ===
  final progress = Get.find<ProgressService>();
  final pointService = Get.find<PointService>();

  // Level didapatkan dari total poin (tiap 100 poin = 1 level)
  int get currentLevel => (pointService.totalPoints.value / 100).floor() + 1;

  // === MISSION NODES (8 nodes) ===
  final List<MissionNode> missionNodes = [
    const MissionNode(
      index: 0,
      title: "Latihan Menulis Huruf",
      subtitle: "Mengenal A-Z",
      emoji: "✏️",
      type: MissionType.writingPractice,
      routeName: '/letter-selection',
      isBoss: false,
      gradient: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
    ),
    const MissionNode(
      index: 1,
      title: "Ujian Menulis Huruf",
      subtitle: "Buktikan kemampuanmu!",
      emoji: "⚔️",
      type: MissionType.writingExam,
      routeName: '/writing-exam',
      arguments: {'category': 'capital', 'title': 'Ujian Menulis Huruf'},
      isBoss: true,
      gradient: [Color(0xFFFF9F1C), Color(0xFFFFD166)],
    ),
    const MissionNode(
      index: 2,
      title: "Latihan Menulis Kata",
      subtitle: "Kata sederhana",
      emoji: "✍️",
      type: MissionType.writingPractice,
      routeName: '/word-selection',
      isBoss: false,
      gradient: [Color(0xFFf7971e), Color(0xFFffd200)],
    ),
    const MissionNode(
      index: 3,
      title: "Ujian Menulis Kata",
      subtitle: "Tantangan kata!",
      emoji: "🏆",
      type: MissionType.writingExam,
      routeName: '/writing-exam',
      arguments: {'category': 'word', 'title': 'Ujian Menulis Kata'},
      isBoss: true,
      gradient: [Color(0xFFEF476F), Color(0xFFFF6B6B)],
    ),
    const MissionNode(
      index: 4,
      title: "Latihan Mengeja Huruf",
      subtitle: "Suara huruf A-Z",
      emoji: "🔤",
      type: MissionType.spellingPractice,
      routeName: '/spelling-letter-selection',
      arguments: {'type': 'letter'},
      isBoss: false,
      gradient: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    ),
    const MissionNode(
      index: 5,
      title: "Ujian Mengeja Huruf",
      subtitle: "Tebak suara huruf!",
      emoji: "🎤",
      type: MissionType.spellingExam,
      routeName: '/spelling-exam',
      arguments: {'category': 'letter', 'title': 'Ujian Mengeja Huruf'},
      isBoss: true,
      gradient: [Color(0xFF06D6A0), Color(0xFF1CB0F6)],
    ),
    const MissionNode(
      index: 6,
      title: "Latihan Mengeja Kata",
      subtitle: "Mengingat ejaan",
      emoji: "🧩",
      type: MissionType.spellingPractice,
      routeName: '/spelling-word-selection',
      arguments: {'type': 'word'},
      isBoss: false,
      gradient: [Color(0xFF9D4EDD), Color(0xFFC77DFF)],
    ),
    const MissionNode(
      index: 7,
      title: "Ujian Mengeja Kata",
      subtitle: "Eja seperti pro",
      emoji: "👑",
      type: MissionType.spellingExam,
      routeName: '/spelling-exam',
      arguments: {'category': 'word', 'title': 'Ujian Mengeja Kata'},
      isBoss: true,
      gradient: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
    ),
    const MissionNode(
      index: 8,
      title: "Berburu Benda 🔍",
      subtitle: "Temukan benda di sekitarmu!",
      emoji: "🔍",
      type: MissionType.objectHuntPractice,
      routeName: '/object-hunt-practice',
      isBoss: false,
      gradient: [Color(0xFF11998E), Color(0xFF38EF7D)],
    ),
    const MissionNode(
      index: 9,
      title: "Ujian Berburu Benda",
      subtitle: "Kejar 5 benda dalam 60 detik!",
      emoji: "⏱️",
      type: MissionType.objectHuntExam,
      routeName: '/object-hunt-exam',
      isBoss: true,
      gradient: [Color(0xFFFC5C7D), Color(0xFF6A3093)],
    ),
  ];

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  /// [DEV MODE] Semua node terbuka untuk keperluan testing
  /// Kembalikan ke: return index <= progress.currentMissionIndex.value; saat deploy
  bool isNodeUnlocked(int index) {
    return true;
  }

  /// Cek apakah node pada index tertentu sudah selesai
  bool isNodeCompleted(int index) {
    return progress.completedMissions.contains(index);
  }

  /// Cek apakah node pada index tertentu adalah node yang sedang aktif
  bool isCurrentNode(int index) {
    return index == progress.currentMissionIndex.value;
  }

  /// Tandai node sebagai selesai dan buka node berikutnya
  void completeNode(int index) {
    if (!progress.completedMissions.contains(index)) {
      List<int> newCompleted = List.from(progress.completedMissions);
      newCompleted.add(index);

      // Buka node berikutnya
      int nextMissionIndex = progress.currentMissionIndex.value;
      if (index == progress.currentMissionIndex.value &&
          progress.currentMissionIndex.value < missionNodes.length - 1) {
        nextMissionIndex++;
      }

      progress.updateMissionProgress(nextMissionIndex, newCompleted);
    }
  }

  /// Navigasi ke halaman latihan/ujian yang sesuai
  void navigateToNode(int index) {
    if (!isNodeUnlocked(index)) return;

    final node = missionNodes[index];

    // Simulasi: Tandai node selesai saat dinavigasi
    // (Di production, ini harusnya setelah user benar-benar menyelesaikan latihan)
    completeNode(index);

    Get.toNamed(node.routeName, arguments: node.arguments);
  }
}
