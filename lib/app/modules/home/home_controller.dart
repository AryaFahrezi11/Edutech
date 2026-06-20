import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/mission_node.dart';

class HomeController extends GetxController {
  var tabIndex = 0.obs; // Untuk navigasi bawah

  // === GAMIFICATION STATE ===
  var currentMissionIndex = 0.obs;           // Index node yang sedang aktif
  var completedMissions = <int>[].obs;       // List index node yang sudah selesai
  var totalXP = 120.obs;                     // Total XP/bintang
  var streakDays = 3.obs;                    // Hari beruntun
  var currentLevel = 1.obs;                  // Level saat ini

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
      routeName: '/spelling-practice',
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
      routeName: '/spelling-practice',
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
  ];

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  /// Cek apakah node pada index tertentu sudah terbuka
  bool isNodeUnlocked(int index) {
    return index <= currentMissionIndex.value;
  }

  /// Cek apakah node pada index tertentu sudah selesai
  bool isNodeCompleted(int index) {
    return completedMissions.contains(index);
  }

  /// Cek apakah node pada index tertentu adalah node yang sedang aktif
  bool isCurrentNode(int index) {
    return index == currentMissionIndex.value;
  }

  /// Tandai node sebagai selesai dan buka node berikutnya
  void completeNode(int index) {
    if (!completedMissions.contains(index)) {
      completedMissions.add(index);

      // Tambah XP
      final node = missionNodes[index];
      totalXP.value += node.isBoss ? 50 : 20;

      // Update level
      currentLevel.value = (totalXP.value / 100).floor() + 1;

      // Buka node berikutnya
      if (index == currentMissionIndex.value &&
          currentMissionIndex.value < missionNodes.length - 1) {
        currentMissionIndex.value++;
      }
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