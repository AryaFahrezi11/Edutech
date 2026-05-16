import 'package:edutech/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class WritingCategoryView extends StatelessWidget {
  const WritingCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      _CategoryData(
        emoji: "🅰️",
        title: "Huruf Kapital",
        subtitle: "A B C D E F ...",
        gradient: [const Color(0xFF6C63FF), const Color(0xFF48C6EF)],
        available: true,
      ),
      _CategoryData(
        emoji: "🔡",
        title: "Huruf Kecil",
        subtitle: "a b c d e f ...",
        gradient: [const Color(0xFF11998E), const Color(0xFF38EF7D)],
        available: false,
      ),
      _CategoryData(
        emoji: "🕌",
        title: "Huruf Hijaiyah",
        subtitle: "ا ب ت ث ...",
        gradient: [const Color(0xFFf7971e), const Color(0xFFffd200)],
        available: false,
      ),
      _CategoryData(
        emoji: "🔢",
        title: "Angka",
        subtitle: "1 2 3 4 5 ...",
        gradient: [const Color(0xFFFF416C), const Color(0xFFFF4B2B)],
        available: false,
      ),
      _CategoryData(
        emoji: "🖼️",
        title: "Kata Sederhana",
        subtitle: "Kucing, Meja ...",
        gradient: [const Color(0xFF9D4EDD), const Color(0xFFC77DFF)],
        available: false,
      ),
      _CategoryData(
        emoji: "✍️",
        title: "Kalimat Pendek",
        subtitle: "Aku suka belajar!",
        gradient: [const Color(0xFF0096C7), const Color(0xFF48CAE4)],
        available: false,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: SafeArea(
        child: Column(
          children: [
            // ─── HEADER ─────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(8, 12, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        onPressed: () => Get.back(),
                      ),
                      const Expanded(
                        child: Text(
                          "Latihan Menulis ✏️",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Mascot + Motivasi
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Text("📝", style: TextStyle(fontSize: 36)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Pilih kategori yang ingin dipelajari!",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Mulai dari huruf kapital dulu ya 😊",
                                style: TextStyle(fontSize: 12, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ─── GRID KATEGORI ────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 10),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (ctx, i) {
                    final cat = categories[i];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(milliseconds: 400 + i * 100),
                      curve: Curves.easeOutBack,
                      builder: (ctx, v, child) => Transform.scale(scale: v, child: child),
                      child: _CategoryCard(data: cat),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── DATA MODEL ───────────────────────────────────────────────────────────────
class _CategoryData {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final bool available;

  const _CategoryData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.available,
  });
}

// ─── CATEGORY CARD WIDGET ─────────────────────────────────────────────────────
class _CategoryCard extends StatefulWidget {
  final _CategoryData data;
  const _CategoryCard({required this.data});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 110), lowerBound: 0, upperBound: 0.04);
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(_ctrl);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _handleTap() {
    if (!widget.data.available) {
      Get.snackbar(
        "Segera Hadir! 🚀",
        "${widget.data.title} akan segera tersedia. Terus semangat belajar!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF6C63FF).withOpacity(0.92),
        colorText: Colors.white,
        borderRadius: 20,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.hourglass_top_rounded, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
      return;
    }
    Get.toNamed(Routes.LETTER_SELECTION);
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); _handleTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (ctx, child) => Transform.scale(scale: _scale.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            gradient: d.available
                ? LinearGradient(colors: d.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight)
                : null,
            color: d.available ? null : const Color(0xFFE8E8F0),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: d.available ? d.gradient.last.withOpacity(0.35) : Colors.grey.withOpacity(0.12),
                blurRadius: d.available ? 14 : 6,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // ── Main Content ──
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Emoji icon in a frosted bubble
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: d.available ? Colors.white.withOpacity(0.22) : Colors.grey.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(d.emoji, style: TextStyle(fontSize: 26, color: d.available ? null : const Color(0xFFAAAAAA))),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: d.available ? Colors.white : const Color(0xFF9090A0),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          d.subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: d.available ? Colors.white.withOpacity(0.8) : const Color(0xFFAAAAAA),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ── "Coming Soon" badge for locked categories ──
              if (!d.available)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9090A0).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF9090A0).withOpacity(0.3)),
                    ),
                    child: const Text(
                      "Coming Soon",
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF9090A0)),
                    ),
                  ),
                ),
              // ── Lock icon for locked categories ──
              if (!d.available)
                Positioned(
                  bottom: 14,
                  right: 14,
                  child: Icon(Icons.lock_rounded, size: 18, color: const Color(0xFF9090A0).withOpacity(0.5)),
                ),
              // ── "Mulai" chip for available categories ──
              if (d.available)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Mulai! ▶",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
