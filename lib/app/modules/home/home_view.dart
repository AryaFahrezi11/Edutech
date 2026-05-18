import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import '../../routes/app_routes.dart';
import '../leaderboard/views/leaderboard_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: [
            _buildHomeContent(),
            const Center(
              child: Text(
                "Halaman Belajar (Segera Hadir)",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
            const Center(
              child: Text(
                "Halaman Ujian (Segera Hadir)",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
            const LeaderboardView(),
            const Center(
              child: Text(
                "Halaman Profil (Segera Hadir)",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroBanner(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22),
                  _buildStreakCard(),
                  const SizedBox(height: 22),
                  _buildSectionTitle(
                    "🎮 Pilih Aktivitas",
                    color: const Color(0xFF4A3F8F),
                  ),
                  const SizedBox(height: 14),
                  _buildActivityGrid(),
                  const SizedBox(height: 22),
                  _buildSectionTitle(
                    "🏆 Pencapaianmu",
                    color: const Color(0xFF4A3F8F),
                  ),
                  const SizedBox(height: 14),
                  _buildBadgesRow(),
                  const SizedBox(height: 22),
                  _buildSectionTitle(
                    "📣 Tantangan Hari Ini",
                    color: const Color(0xFF4A3F8F),
                  ),
                  const SizedBox(height: 14),
                  _buildDailyChallenge(),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HERO BANNER (gradient + avatar + stars) ---
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: Column(
        children: [
          // Top row: greeting + notification
          Row(
            children: [
              // Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white,
                  child: Image.network(
                    'https://api.dicebear.com/7.x/avataaars/png?seed=Amrull',
                    width: 44,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Halo, Bintang Kecil! ⭐",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Hari ini kita belajar lagi, yuk!",
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              // Notif button
              _AnimatedBellButton(),
            ],
          ),
          const SizedBox(height: 24),
          // XP Progress bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Text("⚡", style: TextStyle(fontSize: 18)),
                        SizedBox(width: 6),
                        Text(
                          "Level 5 - Pemberani",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      "660 / 1000 XP",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.66,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFFD700),
                    ),
                    minHeight: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- STREAK CARD ---
  Widget _buildStreakCard() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
      builder: (ctx, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - v)),
          child: child,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B6B).withOpacity(0.35),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            const Text("🔥", style: TextStyle(fontSize: 40)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "7 Hari Beruntun!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Kamu keren banget! Jangan berhenti ya 💪",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                "STREAK",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {Color color = Colors.black87}) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color),
    );
  }

  // --- ACTIVITY GRID ---
  Widget _buildActivityGrid() {
    final activities = [
      _ActivityData(
        emoji: "🔤",
        title: "Latihan\nMenulis",
        subtitle: "Nulis itu seru!",
        gradient: [const Color(0xFF11998E), const Color(0xFF38EF7D)],
        onTap: () => Get.toNamed(Routes.WRITING_CATEGORY),
      ),
      _ActivityData(
        emoji: "📖",
        title: "Latihan\nMengeja",
        subtitle: "Baca kata yuk!",
        gradient: [const Color(0xFF6C63FF), const Color(0xFF9D4EDD)],
        onTap: () {},
      ),
      _ActivityData(
        emoji: "✏️",
        title: "Ujian\nMenulis",
        subtitle: "Uji kemampuanmu!",
        gradient: [const Color(0xFFf7971e), const Color(0xFFffd200)],
        onTap: () => Get.toNamed(Routes.WRITING_EXAM_CATEGORY),
      ),
      _ActivityData(
        emoji: "🎙️",
        title: "Ujian\nMengeja",
        subtitle: "Dengerin suara!",
        gradient: [const Color(0xFFFF416C), const Color(0xFFFF4B2B)],
        onTap: () {},
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.9,
      ),
      itemCount: activities.length,
      itemBuilder: (ctx, i) {
        final a = activities[i];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 500 + i * 120),
          curve: Curves.easeOutBack,
          builder: (ctx, v, child) => Transform.scale(scale: v, child: child),
          child: _ActivityCard(data: a),
        );
      },
    );
  }

  // --- BADGES ROW ---
  Widget _buildBadgesRow() {
    final badges = [
      {"emoji": "🌟", "label": "Bintang\nPertama", "earned": true},
      {"emoji": "📚", "label": "Rajin\nBaca", "earned": true},
      {"emoji": "✍️", "label": "Jago\nMenulis", "earned": true},
      {"emoji": "🏅", "label": "Juara\nKelas", "earned": false},
      {"emoji": "🚀", "label": "Roket\nBelajar", "earned": false},
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: badges.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (ctx, i) {
          final b = badges[i];
          final earned = b["earned"] as bool;
          return Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: earned
                      ? const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFFAA00)],
                        )
                      : null,
                  color: earned ? null : Colors.grey[200],
                  boxShadow: earned
                      ? [
                          BoxShadow(
                            color: const Color(0xFFFFD700).withOpacity(0.45),
                            blurRadius: 10,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    b["emoji"] as String,
                    style: TextStyle(
                      fontSize: 28,
                      color: earned ? null : const Color(0xFFCCCCCC),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                b["label"] as String,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: earned ? const Color(0xFF4A3F8F) : Colors.grey[400],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- DAILY CHALLENGE ---
  Widget _buildDailyChallenge() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (ctx, v, child) => Opacity(opacity: v, child: child),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text("🎯", style: TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tantangan: Eja Kata Baru!",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: Color(0xFF4A3F8F),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Selesaikan 3 soal mengeja hari ini",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "+50 XP",
                    style: TextStyle(
                      color: Color(0xFF6C63FF),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(
                3,
                (i) => Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                    height: 10,
                    decoration: BoxDecoration(
                      color: i < 2 ? const Color(0xFF6C63FF) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "2 dari 3 selesai!",
              style: TextStyle(
                color: Color(0xFF6C63FF),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                child: const Text(
                  "Lanjut Tantangan! 🚀",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- CUSTOM BOTTOM NAV ---
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.tabIndex.value,
          onTap: controller.changeTabIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF6C63FF),
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 10,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
          items: [
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.home_rounded,
                selected: controller.tabIndex.value == 0,
              ),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.menu_book_rounded,
                selected: controller.tabIndex.value == 1,
              ),
              label: 'Belajar',
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.quiz_rounded,
                selected: controller.tabIndex.value == 2,
              ),
              label: 'Ujian',
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.emoji_events_rounded,
                selected: controller.tabIndex.value == 3,
              ),
              label: 'Ranking',
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.person_rounded,
                selected: controller.tabIndex.value == 4,
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

// --- SUB WIDGETS ---

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  const _NavIcon({required this.icon, required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF6C63FF).withOpacity(0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        size: 24,
        color: selected ? const Color(0xFF6C63FF) : Colors.grey[400],
      ),
    );
  }
}

class _AnimatedBellButton extends StatefulWidget {
  @override
  State<_AnimatedBellButton> createState() => _AnimatedBellButtonState();
}

class _AnimatedBellButtonState extends State<_AnimatedBellButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _shake;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shake = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticIn));
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted)
        _ctrl.repeat(reverse: true, period: const Duration(seconds: 3));
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shake,
      builder: (ctx, child) => Transform.rotate(
        angle: sin(_shake.value * pi * 2) * 0.2,
        child: child,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.notifications_rounded,
              color: Colors.white,
              size: 24,
            ),
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B6B),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityData {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;
  const _ActivityData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });
}

class _ActivityCard extends StatefulWidget {
  final _ActivityData data;
  const _ActivityCard({required this.data});

  @override
  State<_ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<_ActivityCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.data.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (ctx, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.data.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: widget.data.gradient.last.withOpacity(0.4),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    widget.data.emoji,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.data.subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
