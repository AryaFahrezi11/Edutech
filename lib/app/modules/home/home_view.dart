import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'home_controller.dart';

import '../leaderboard/views/leaderboard_view.dart';
import '../profile/views/profile_view.dart';
import '../multiplayer/views/multiplayer_menu_view.dart';
import 'widgets/mission_node_widget.dart';
import 'widgets/mission_path_painter.dart';
import 'widgets/stats_bar_widget.dart';

import '/app/services/point_service.dart';
import '../../routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: [
            _buildMissionMapContent(),
            const MultiplayerMenuView(), // NEW TAB
            const LeaderboardView(),
            const ProfileView(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  /// ─── MISSION MAP (Tab Utama) ──────────────────────────────────────────
  Widget _buildMissionMapContent() {
    return SafeArea(
      child: Column(
        children: [
          // Header dengan avatar dan stats
          _buildGameHeader(),

          // Stats Bar
          const StatsBarWidget(),

          const SizedBox(height: 8),

          // Mission Map (scrollable)
          Expanded(child: _buildMissionMap()),
        ],
      ),
    );
  }

  /// ─── HEADER GAME ──────────────────────────────────────────────────────
  Widget _buildGameHeader() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -60 * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1CB0F6).withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFFFD166),
                child: Obx(() => Text(controller.userAvatar.value, style: const TextStyle(fontSize: 26))),
              ),
            ),
            const SizedBox(width: 14),
            // Nama dan subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    "Halo, ${controller.userName.value} ! 🌟",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  )),
                  const SizedBox(height: 2),
                  Obx(
                    () => Text(
                      "Misi ${controller.progress.completedMissions.length}/${controller.missionNodes.length} selesai",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Coin Badge
            Obx(() {
              final points = Get.find<PointService>().totalPoints.value;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("⭐", style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      "$points",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// ─── PETA MISI (MAIN CONTENT) ────────────────────────────────────────
  Widget _buildMissionMap() {
    final nodeCount = controller.missionNodes.length;
    const nodeSpacing = 140.0;
    const zigzagOffset = 70.0;

    // Hitung scroll controller supaya scroll ke current node
    final scrollController = ScrollController();

    // Delay scroll ke current node
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentIndex = controller.progress.currentMissionIndex.value;
      // Reversed index karena list ditampilkan terbalik (bawah ke atas)
      final reversedIndex = nodeCount - 1 - currentIndex;
      final targetScroll = reversedIndex * nodeSpacing - 200;
      if (scrollController.hasClients) {
        scrollController.animateTo(
          targetScroll.clamp(0.0, scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
        );
      }
    });

    return Obx(() {
      // Force rebuild saat completedMissions berubah
      final _ =
          controller.progress.completedMissions.length +
          controller.progress.currentMissionIndex.value;

      return Stack(
        children: [
          // Background dekoratif
          _buildMapBackground(),

          // Scrollable Mission Map
          SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: SizedBox(
              width: double.infinity,
              height: nodeCount * nodeSpacing + 60,
              child: Stack(
                children: [
                  // Dashed path lines
                  Positioned.fill(
                    child: CustomPaint(
                      painter: MissionPathPainter(
                        nodeCount: nodeCount,
                        currentNodeIndex: controller.progress.currentMissionIndex.value,
                        nodeSpacing: nodeSpacing,
                        zigzagOffset: zigzagOffset,
                      ),
                    ),
                  ),

                  // Mission Node Widgets — ditampilkan dari atas (node terakhir) ke bawah (node pertama)
                  ...List.generate(nodeCount, (i) {
                    final reversedIndex = nodeCount - 1 - i;
                    final node = controller.missionNodes[reversedIndex];

                    final yPos = i * nodeSpacing + nodeSpacing / 2 - 34;

                    final screenWidth = Get.width;
                    final centerX = screenWidth / 2;
                    final patterns = [-zigzagOffset, 0.0, zigzagOffset, 0.0];
                    final xOffset = patterns[i % patterns.length];
                    final xPos = centerX + xOffset - 50;

                    // Tentukan Lottie untuk lekukan
                    String? lottieAsset;
                    double? lottieX;
                    if (i % 2 == 0) { // di lekukan (kiri/kanan), bukan di tengah (0.0)
                       final lotties = [
                        'assets/lotties/search.json',
                        'assets/lotties/cute-cat.json',
                        'assets/lotties/dog.json',
                        'assets/lotties/owl.json',
                        'assets/lotties/pencil.json',
                        'assets/lotties/rabbit.json',
                      ];
                      lottieAsset = lotties[(i ~/ 2) % lotties.length];
                      if (xOffset < 0) {
                        lottieX = centerX + zigzagOffset + 10; // node kiri, lottie kanan
                      } else if (xOffset > 0) {
                        lottieX = centerX - zigzagOffset - 80; // node kanan, lottie kiri
                      }
                    }

                    return [
                      if (lottieAsset != null && lottieX != null)
                        Positioned(
                          left: lottieX,
                          top: yPos - 10,
                          child: Opacity(
                            opacity: 0.85,
                            child: Lottie.asset(lottieAsset, width: 80, height: 80),
                          ),
                        ),
                      Positioned(
                        left: xPos,
                        top: yPos,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: Duration(milliseconds: 400 + (i * 60)),
                          curve: Curves.easeOutBack,
                          builder: (_, v, child) {
                            return Transform.scale(
                              scale: v.clamp(0.0, 1.2),
                              child: Opacity(
                                opacity: v.clamp(0.0, 1.0),
                                child: child,
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 100,
                            child: MissionNodeWidget(
                              node: node,
                              isCompleted: controller.isNodeCompleted(reversedIndex),
                              isCurrent: controller.isCurrentNode(reversedIndex),
                              isUnlocked: controller.isNodeUnlocked(reversedIndex),
                              onTap: () => controller.navigateToNode(reversedIndex),
                            ),
                          ),
                        ),
                      ),
                    ];
                  }).expand((e) => e),

                  // Dekorasi: awan dan bintang di sepanjang path
                  ..._buildDecorations(nodeCount, nodeSpacing),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  /// ─── BACKGROUND DEKORATIF ────────────────────────────────────────────
  Widget _buildMapBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE8F5E9), // hijau muda atas
            Color(0xFFF0F7FF), // biru muda tengah
            Color(0xFFFFF8E1), // kuning muda bawah
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  /// ─── DEKORASI AWAN & BINTANG ─────────────────────────────────────────
  List<Widget> _buildDecorations(int nodeCount, double nodeSpacing) {
    final decorations = <Widget>[];
    final random = Random(42); // Fixed seed untuk konsistensi

    final emojis = ["☁️", "⭐", "🌸", "🌿", "🦋", "🍀", "✨"];

    for (int i = 0; i < nodeCount * 2; i++) {
      final yPos = random.nextDouble() * (nodeCount * nodeSpacing);
      final isLeft = random.nextBool();
      final xPos = isLeft
          ? random.nextDouble() * 50 + 10 // kiri
          : Get.width - random.nextDouble() * 50 - 60; // kanan

      final emoji = emojis[random.nextInt(emojis.length)];
      final size = 14.0 + random.nextDouble() * 10;
      decorations.add(
        Positioned(
          left: xPos,
          top: yPos,
          child: Opacity(
            opacity: 0.3 + random.nextDouble() * 0.3,
            child: Text(emoji, style: TextStyle(fontSize: size)),
          ),
        ),
      );
    }

    return decorations;
  }

  /// ─── BOTTOM NAVIGATION ───────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.tabIndex.value,
            onTap: controller.changeTabIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: const Color(0xFF1CB0F6),
            unselectedItemColor: const Color(0xFFCBD5E1),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.map_rounded, size: 28),
                label: 'Peta Misi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.sports_esports_rounded, size: 28),
                label: 'Arena Duel',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events_rounded, size: 28),
                label: 'Piala',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.face_rounded, size: 28),
                label: 'Aku',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
