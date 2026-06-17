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

  // === MISSION NODES (15 nodes, ujian setiap 5 langkah) ===
  final List<MissionNode> missionNodes = [
    // --- Siklus 1: Level Huruf ---
    const MissionNode(
      index: 0,
      title: "Menulis Huruf",
      subtitle: "Mengenal A B C",
      emoji: "✏️",
      type: MissionType.writingPractice,
      routeName: '/letter-selection',
      isBoss: false,
      gradient: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
    ),
    const MissionNode(
      index: 1,
      title: "Mengeja Huruf",
      subtitle: "Suara huruf A-Z",
      emoji: "🔤",
      type: MissionType.spellingPractice,
      routeName: '/spelling-practice',
      arguments: {'type': 'letter'},
      isBoss: false,
      gradient: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    ),
    const MissionNode(
      index: 2,
      title: "Latihan Huruf",
      subtitle: "Menulis lebih lancar",
      emoji: "🖊️",
      type: MissionType.writingPractice,
      routeName: '/letter-selection',
      isBoss: false,
      gradient: [Color(0xFF11998E), Color(0xFF38EF7D)],
    ),
    const MissionNode(
      index: 3,
      title: "Tebak Huruf",
      subtitle: "Mengingat suara",
      emoji: "🗣️",
      type: MissionType.spellingPractice,
      routeName: '/spelling-practice',
      arguments: {'type': 'letter'},
      isBoss: false,
      gradient: [Color(0xFF7F7FD5), Color(0xFF86A8E7)],
    ),
    const MissionNode(
      index: 4,
      title: "Ujian Huruf",
      subtitle: "Buktikan kemampuanmu!",
      emoji: "⚔️",
      type: MissionType.writingExam,
      routeName: '/writing-exam',
      arguments: {'category': 'capital', 'title': 'Ujian Huruf'},
      isBoss: true,
      gradient: [Color(0xFFFF9F1C), Color(0xFFFFD166)],
    ),

    // --- Siklus 2: Level Kata ---
    const MissionNode(
      index: 5,
      title: "Menulis Kata",
      subtitle: "Kata sederhana",
      emoji: "✍️",
      type: MissionType.writingPractice,
      routeName: '/word-selection',
      isBoss: false,
      gradient: [Color(0xFFf7971e), Color(0xFFffd200)],
    ),
    const MissionNode(
      index: 6,
      title: "Mengeja Kata",
      subtitle: "Suara kata penuh",
      emoji: "🎤",
      type: MissionType.spellingPractice,
      routeName: '/spelling-practice',
      arguments: {'type': 'word'},
      isBoss: false,
      gradient: [Color(0xFF06D6A0), Color(0xFF1CB0F6)],
    ),
    const MissionNode(
      index: 7,
      title: "Kata Baru",
      subtitle: "Latihan kata lain",
      emoji: "📝",
      type: MissionType.writingPractice,
      routeName: '/word-selection',
      isBoss: false,
      gradient: [Color(0xFF9D4EDD), Color(0xFFC77DFF)],
    ),
    const MissionNode(
      index: 8,
      title: "Tebak Kata",
      subtitle: "Mengingat ejaan",
      emoji: "🧩",
      type: MissionType.spellingPractice,
      routeName: '/spelling-practice',
      arguments: {'type': 'word'},
      isBoss: false,
      gradient: [Color(0xFF0096C7), Color(0xFF48CAE4)],
    ),
    const MissionNode(
      index: 9,
      title: "Ujian Kata",
      subtitle: "Tantangan mengeja!",
      emoji: "🏆",
      type: MissionType.spellingExam,
      routeName: '/spelling-exam',
      arguments: {'category': 'word', 'title': 'Ujian Mengeja Kata'},
      isBoss: true,
      gradient: [Color(0xFFEF476F), Color(0xFFFF6B6B)],
    ),

    // --- Siklus 3: Level Mahir ---
    const MissionNode(
      index: 10,
      title: "Huruf Cepat",
      subtitle: "Kecepatan menulis",
      emoji: "🚀",
      type: MissionType.writingPractice,
      routeName: '/letter-selection',
      isBoss: false,
      gradient: [Color(0xFF667EEA), Color(0xFF764BA2)],
    ),
    const MissionNode(
      index: 11,
      title: "Kata Cepat",
      subtitle: "Eja seperti pro",
      emoji: "🌟",
      type: MissionType.spellingPractice,
      routeName: '/spelling-practice',
      arguments: {'type': 'word'},
      isBoss: false,
      gradient: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
    ),
    const MissionNode(
      index: 12,
      title: "Ahli Menulis",
      subtitle: "Menulis expert",
      emoji: "🎨",
      type: MissionType.writingPractice,
      routeName: '/word-selection',
      isBoss: false,
      gradient: [Color(0xFF43E97B), Color(0xFF38F9D7)],
    ),
    const MissionNode(
      index: 13,
      title: "Raja Eja",
      subtitle: "Tak terkalahkan!",
      emoji: "👑",
      type: MissionType.spellingPractice,
      routeName: '/spelling-practice',
      arguments: {'type': 'word'},
      isBoss: false,
      gradient: [Color(0xFFFFC107), Color(0xFFFF9800)],
    ),
    const MissionNode(
      index: 14,
      title: "UJIAN AKHIR",
      subtitle: "Pertempuran terakhir!",
      emoji: "🐉",
      type: MissionType.writingExam,
      routeName: '/writing-exam',
      arguments: {'category': 'capital', 'title': 'Ujian Akhir'},
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