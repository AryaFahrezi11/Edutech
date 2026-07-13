import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/mission_node.dart';
import '/app/services/progress_service.dart';
import '/app/services/point_service.dart';
import '/app/services/tts_service.dart';
import '/app/services/sfx_service.dart';

class HomeController extends GetxController {
  var tabIndex = 0.obs; // Untuk navigasi bawah
  var userName = "Petualang".obs; // Tambahan untuk nama user
  var userAvatar = "🧒".obs; // Tambahan untuk avatar user

  // === GAMIFICATION STATE ===
  final progress = Get.find<ProgressService>();
  final pointService = Get.find<PointService>();

  @override
  void onInit() {
    super.onInit();
    _loadUserName();
  }

  @override
  void onReady() {
    super.onReady();
    _checkDailyReward();
  }

  void _checkDailyReward() {
    int earned = pointService.checkDailyLogin();
    if (earned > 0) {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "🎉 Hadiah Harian! 🎉",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3A2F6B),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "⭐",
                  style: TextStyle(fontSize: 60),
                ),
                const SizedBox(height: 16),
                Text(
                  "Kamu mendapatkan +$earned Bintang karena rajin belajar hari ini!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1CB0F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text(
                    "Asyik!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
      
      // Putar suara success/coin
      try {
        Get.find<SfxService>().playSuccess();
      } catch (_) {}
    }
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('user_name') ?? "Petualang";
    userAvatar.value = prefs.getString('user_avatar') ?? "🧒";
  }

  // Level didapatkan dari total poin (tiap 100 poin = 1 level)
  int get currentLevel => (pointService.totalPoints.value / 100).floor() + 1;

  // === MISSION NODES (8 nodes) ===
  final List<MissionNode> missionNodes = [
    const MissionNode(
      index: 0,
      title: "Latihan Menulis Huruf",
      subtitle: "Mengenal A-Z (Kapital)",
      emoji: "✏️",
      type: MissionType.writingPractice,
      routeName: '/letter-selection',
      arguments: {'category': 'uppercase'},
      isBoss: false,
      gradient: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
    ),
    const MissionNode(
      index: 1,
      title: "Ujian Menulis Huruf",
      subtitle: "Uji Kapital!",
      emoji: "⚔️",
      type: MissionType.writingExam,
      routeName: '/writing-exam-menu',
      arguments: {'category': 'capital', 'title': 'Ujian Huruf Kapital'},
      isBoss: true,
      gradient: [Color(0xFFFF9F1C), Color(0xFFFFD166)],
    ),
    const MissionNode(
      index: 2,
      title: "Latihan Huruf Kecil",
      subtitle: "Mengenal a-z (Kecil)",
      emoji: "🔡",
      type: MissionType.writingPractice,
      routeName: '/letter-selection',
      arguments: {'category': 'lowercase'},
      isBoss: false,
      gradient: [Color(0xFF11998E), Color(0xFF38EF7D)],
    ),
    const MissionNode(
      index: 3,
      title: "Ujian Huruf Kecil",
      subtitle: "Uji Kecil!",
      emoji: "🎓",
      type: MissionType.writingExam,
      routeName: '/writing-exam-menu',
      arguments: {'category': 'lowercase', 'title': 'Ujian Huruf Kecil'},
      isBoss: true,
      gradient: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
    ),
    const MissionNode(
      index: 4,
      title: "Latihan Menulis Kata",
      subtitle: "Kata sederhana",
      emoji: "✍️",
      type: MissionType.writingPractice,
      routeName: '/word-selection',
      isBoss: false,
      gradient: [Color(0xFFf7971e), Color(0xFFffd200)],
    ),
    const MissionNode(
      index: 5,
      title: "Ujian Menulis Kata",
      subtitle: "Tantangan kata!",
      emoji: "🏆",
      type: MissionType.writingExam,
      routeName: '/writing-exam-menu',
      arguments: {'category': 'word', 'title': 'Ujian Menulis Kata'},
      isBoss: true,
      gradient: [Color(0xFFEF476F), Color(0xFFFF6B6B)],
    ),
    const MissionNode(
      index: 6,
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
      index: 7,
      title: "Ujian Mengeja Huruf",
      subtitle: "Tebak suara huruf!",
      emoji: "🎤",
      type: MissionType.spellingExam,
      routeName: '/spelling-exam-menu',
      arguments: {'category': 'capital', 'title': 'Ujian Mengeja Huruf'},
      isBoss: true,
      gradient: [Color(0xFF06D6A0), Color(0xFF1CB0F6)],
    ),
    const MissionNode(
      index: 8,
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
      index: 9,
      title: "Ujian Mengeja Kata",
      subtitle: "Eja seperti pro",
      emoji: "👑",
      type: MissionType.spellingExam,
      routeName: '/spelling-exam-menu',
      arguments: {'category': 'word', 'title': 'Ujian Mengeja Kata'},
      isBoss: true,
      gradient: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
    ),
    const MissionNode(
      index: 10,
      title: "Detektif Benda 🔍",
      subtitle: "Temukan benda di sekitarmu!",
      emoji: "🔍",
      type: MissionType.objectHuntPractice,
      routeName: '/object-hunt-selection',
      isBoss: false,
      gradient: [Color(0xFF11998E), Color(0xFF38EF7D)],
    ),
    const MissionNode(
      index: 11,
      title: "Ujian Detektif Benda",
      subtitle: "Kejar 5 benda dalam 60 detik!",
      emoji: "⏱️",
      type: MissionType.objectHuntExam,
      routeName: '/object-hunt-exam',
      isBoss: true,
      gradient: [Color(0xFFFC5C7D), Color(0xFF6A3093)],
    ),
    const MissionNode(
      index: 12,
      title: "Tebak Benda 🎤",
      subtitle: "Benda apakah ini?",
      emoji: "🎤",
      type: MissionType.guessObjectPractice,
      routeName: '/guess-object-camera',
      isBoss: false,
      gradient: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
    ),
  ];

  void changeTabIndex(int index) {
    tabIndex.value = index;
    if (index == 2) {
      Get.find<TtsService>().speak(
        "Ini adalah papan peringkat! Siapakah yang paling rajin belajar?",
      );
    } else if (index == 1) {
      Get.find<TtsService>().speak(
        "Selamat datang di Arena Duel! Pilih mode permainanmu!",
      );
    }
  }

  /// Cek apakah node terkunci
  bool isNodeUnlocked(int index) {
    return index <= progress.currentMissionIndex.value;
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
    if (!isNodeUnlocked(index)) {
      Get.snackbar(
        "Terkunci 🔒", 
        "Selesaikan misi sebelumnya dulu ya!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    if (index == progress.currentMissionIndex.value && progress.hasNewUnlockedNode.value) {
      progress.hasNewUnlockedNode.value = false;
      SharedPreferences.getInstance().then((prefs) => prefs.setBool('has_new_unlocked_node', false));
    }

    final node = missionNodes[index];
    final args = node.arguments != null ? Map<String, dynamic>.from(node.arguments!) : <String, dynamic>{};
    args['mission_index'] = index;

    Get.toNamed(node.routeName, arguments: args);
  }
}
