import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../../../routes/app_routes.dart';

class WritingCategoryView extends StatelessWidget {
  const WritingCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      _CategoryData(emoji: "🅰️", title: "Huruf Kapital", subtitle: "A B C D E F ...", color: EduTheme.primary, available: true),
      _CategoryData(emoji: "🔡", title: "Huruf Kecil", subtitle: "a b c d e f ...", color: EduTheme.blue, available: false),
      _CategoryData(emoji: "🕌", title: "Huruf Hijaiyah", subtitle: "ا ب ت ث ...", color: EduTheme.orange, available: false),
      _CategoryData(emoji: "🔢", title: "Angka", subtitle: "1 2 3 4 5 ...", color: EduTheme.red, available: false),
      _CategoryData(emoji: "🖼️", title: "Kata Sederhana", subtitle: "Kucing, Meja ...", color: EduTheme.purple, available: true),
      _CategoryData(emoji: "✍️", title: "Kalimat Pendek", subtitle: "Aku suka belajar!", color: const Color(0xFF0096C7), available: false),
    ];

    return Scaffold(
      backgroundColor: EduTheme.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER ──
            Container(
              padding: const EdgeInsets.fromLTRB(8, 12, 20, 20),
              decoration: EduTheme.headerDecoration(gradient: EduTheme.primaryGradient),
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
                          "✏️ Latihan Menulis",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(EduTheme.radiusMd),
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
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
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

            // ── GRID ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 10),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 1.0,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (ctx, i) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(milliseconds: 400 + i * 100),
                      curve: Curves.easeOutBack,
                      builder: (ctx, v, child) => Transform.scale(scale: v.clamp(0.0, 1.2), child: Opacity(opacity: v.clamp(0.0, 1.0), child: child)),
                      child: _CategoryCard(data: categories[i]),
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

class _CategoryData {
  final String emoji, title, subtitle;
  final Color color;
  final bool available;
  const _CategoryData({required this.emoji, required this.title, required this.subtitle, required this.color, required this.available});
}

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
      Get.snackbar("Segera Hadir! 🚀", "${widget.data.title} akan segera tersedia!",
        snackPosition: SnackPosition.BOTTOM, backgroundColor: EduTheme.primary, colorText: Colors.white,
        borderRadius: 20, margin: const EdgeInsets.all(16), duration: const Duration(seconds: 2));
      return;
    }
    
    if (widget.data.title == "Kata Sederhana") {
      Get.toNamed(Routes.WORD_SELECTION);
    } else {
      Get.toNamed(Routes.LETTER_SELECTION);
    }
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
            color: d.available ? d.color : EduTheme.disabled,
            borderRadius: BorderRadius.circular(EduTheme.radiusLg),
            border: Border.all(color: Colors.white.withOpacity(d.available ? 0.3 : 0), width: 3),
            boxShadow: d.available
                ? [BoxShadow(color: d.color.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 5))]
                : EduTheme.softShadow(),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(
                        color: (d.available ? Colors.white : Colors.grey).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(child: Text(d.emoji, style: const TextStyle(fontSize: 26))),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: d.available ? Colors.white : EduTheme.textLight)),
                        const SizedBox(height: 3),
                        Text(d.subtitle, style: TextStyle(fontSize: 11, color: d.available ? Colors.white70 : EduTheme.textLight)),
                      ],
                    ),
                  ],
                ),
              ),
              if (!d.available) Positioned(top: 10, right: 10, child: Icon(Icons.lock_rounded, size: 18, color: EduTheme.textLight)),
              if (d.available) Positioned(
                bottom: 12, right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(12)),
                  child: const Text("Mulai ▶", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
