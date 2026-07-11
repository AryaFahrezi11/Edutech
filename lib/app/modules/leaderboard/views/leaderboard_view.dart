import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../controllers/leaderboard_controller.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EduTheme.bgLight,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: EduTheme.primary));
          }

          final data = controller.leaderboardData;
          
          // Pisahkan top 3 untuk podium, sisanya untuk list
          final top3 = data.length >= 3 ? data.sublist(0, 3) : data.toList();
          final others = data.length > 3 ? data.sublist(3) : [];

          // Helper untuk mengambil data atau default
          Map<String, dynamic> getRankData(int index) {
            if (index < top3.length) return top3[index];
            return {"name": "-", "score": "0", "emoji": "🧒"};
          }

          final rank1 = getRankData(0);
          final rank2 = getRankData(1);
          final rank3 = getRankData(2);

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchLeaderboard();
            },
            color: EduTheme.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // ── HEADER GAMIFIKASI ──
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFB75E), Color(0xFFED8F03)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFED8F03).withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '🏆 Papan Peringkat 🏆',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: [
                                  Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Tarik ke bawah untuk menyegarkan 🔄',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── PODIUM TOP 3 ──
                      if (top3.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (top3.length >= 2)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => controller.playUserRank("2", rank2["name"].toString(), rank2["score"].toString()),
                                    child: _podiumCard(
                                      name: rank2["name"].toString(),
                                      score: rank2["score"].toString(),
                                      height: 78,
                                      rank: "2",
                                      emoji: rank2["emoji"].toString(),
                                      color: const Color(0xFFC0C0C0),
                                      bgColor: const Color(0xFFF0F0F0),
                                    ),
                                  ),
                                )
                              else
                                const Expanded(child: SizedBox()),
                              
                              const SizedBox(width: 8),
                              
                              if (top3.isNotEmpty)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => controller.playUserRank("1", rank1["name"].toString(), rank1["score"].toString()),
                                    child: _podiumCard(
                                      name: rank1["name"].toString(),
                                      score: rank1["score"].toString(),
                                      height: 110,
                                      rank: "1",
                                      emoji: rank1["emoji"].toString(),
                                      color: EduTheme.gold,
                                      bgColor: const Color(0xFFFFF8E1),
                                      center: true,
                                    ),
                                  ),
                                ),
                                
                              const SizedBox(width: 8),
                              
                              if (top3.length >= 3)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => controller.playUserRank("3", rank3["name"].toString(), rank3["score"].toString()),
                                    child: _podiumCard(
                                      name: rank3["name"].toString(),
                                      score: rank3["score"].toString(),
                                      height: 65,
                                      rank: "3",
                                      emoji: rank3["emoji"].toString(),
                                      color: const Color(0xFFCD7F32),
                                      bgColor: const Color(0xFFFFF3E0),
                                    ),
                                  ),
                                )
                              else
                                const Expanded(child: SizedBox()),
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      // ── LIST HEADER ──
                      if (others.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '🌟 Peringkat Lainnya',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: EduTheme.textDark,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                // ── RANK LIST ──
                if (others.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = others[index];
                          return TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: Duration(milliseconds: 400 + index * 100),
                            curve: Curves.easeOutBack,
                            builder: (_, v, child) => Transform.translate(
                              offset: Offset(30 * (1 - v), 0),
                              child: Opacity(opacity: v, child: child),
                            ),
                            child: _rankTile(
                              rank: item["rank"].toString(),
                              name: item["name"].toString(),
                              score: item["score"].toString(),
                              emoji: item["emoji"]?.toString() ?? "🧒",
                              active: item["active"] == true,
                              onTap: () => controller.playUserRank(item["rank"].toString(), item["name"].toString(), item["score"].toString()),
                            ),
                          );
                        },
                        childCount: others.length,
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _podiumCard({
    required String name,
    required String score,
    required double height,
    required String rank,
    required String emoji,
    required Color color,
    required Color bgColor,
    bool center = false,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: center ? 600 : 800),
      curve: Curves.easeOutBack,
      builder: (_, v, child) => Transform.scale(
        scale: v.clamp(0.0, 1.0),
        child: Opacity(opacity: v.clamp(0.0, 1.0), child: child),
      ),
      child: Column(
        children: [
          // Crown untuk rank 1
          if (center) ...[
            const Text("👑", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
          ],
          // Avatar
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 3),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: center ? 30 : 24,
              backgroundColor: bgColor,
              child: Text(emoji, style: TextStyle(fontSize: center ? 32 : 26)),
            ),
          ),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: EduTheme.textDark)),
          Text(
            score,
            style: const TextStyle(color: EduTheme.textMedium, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          // Podium
          Container(
            height: height,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                rank,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rankTile({
    required String rank,
    required String name,
    required String score,
    required String emoji,
    bool active = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(EduTheme.radiusMd),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: active ? EduTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(EduTheme.radiusMd),
          border: active ? null : Border.all(color: EduTheme.border, width: 2),
          boxShadow: active
              ? EduTheme.buttonShadow(EduTheme.primary)
              : EduTheme.softShadow(),
        ),
        child: Row(
          children: [
            // Rank number
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: active ? Colors.white.withOpacity(0.2) : const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  rank,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: active ? Colors.white : EduTheme.textMedium,
                  ),
                ),
              ),
          ),
          const SizedBox(width: 12),
          // Emoji avatar
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          // Name
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: active ? Colors.white : EduTheme.textDark,
              ),
            ),
          ),
          // Score badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: active ? Colors.white.withOpacity(0.2) : EduTheme.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("⭐ ", style: TextStyle(fontSize: active ? 12 : 14)),
                Text(
                  score,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    color: active ? Colors.white : EduTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
