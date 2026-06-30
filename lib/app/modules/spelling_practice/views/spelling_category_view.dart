import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../../../routes/app_routes.dart';

class SpellingCategoryView extends StatelessWidget {
  const SpellingCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      _CategoryData(emoji: "🔤", title: "Huruf A - Z", subtitle: "A a • B b • C c ...", color: EduTheme.blue, available: true),
      _CategoryData(emoji: "🕌", title: "Huruf Hijaiyah", subtitle: "ا ب ت ث ...", color: EduTheme.orange, available: false),
      _CategoryData(emoji: "🔢", title: "Angka", subtitle: "1 2 3 4 5 ...", color: EduTheme.red, available: false),
      _CategoryData(emoji: "🧩", title: "Kata Mudah", subtitle: "Bola, Buku ...", color: EduTheme.purple, available: true),
    ];

    return Scaffold(
      backgroundColor: EduTheme.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(8, 12, 20, 20),
              decoration: EduTheme.headerDecoration(gradient: EduTheme.blueGradient),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20)),
                      const Expanded(child: Text("🔤 Latihan Mengeja", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white))),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(EduTheme.radiusMd)),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Belajar Huruf Dengan Seru ✨", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                        SizedBox(height: 6),
                        Text("Pilih kategori lalu mulai belajar mengeja", style: TextStyle(fontSize: 13, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
                child: GridView.builder(
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 1.0),
                  itemBuilder: (context, index) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(milliseconds: 400 + index * 100),
                      curve: Curves.easeOutBack,
                      builder: (_, v, child) => Transform.scale(scale: v.clamp(0.0, 1.2), child: Opacity(opacity: v.clamp(0.0, 1.0), child: child)),
                      child: _CategoryCard(data: categories[index]),
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
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 120), lowerBound: 0, upperBound: 0.04);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void _handleTap() {
    final d = widget.data;
    if (!d.available) {
      Get.snackbar("Segera Hadir 🚀", "${d.title} akan segera tersedia",
        snackPosition: SnackPosition.BOTTOM, backgroundColor: EduTheme.blue, colorText: Colors.white, borderRadius: 20, margin: const EdgeInsets.all(16));
      return;
    }
    if (d.title == "Kata Mudah") {
      Get.toNamed(Routes.SPELLING_WORD_SELECTION);
    } else {
      Get.toNamed(Routes.SPELLING_LETTER_SELECTION);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) { _controller.reverse(); _handleTap(); },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            color: d.available ? d.color : EduTheme.disabled,
            borderRadius: BorderRadius.circular(EduTheme.radiusLg),
            border: Border.all(color: Colors.white.withOpacity(d.available ? 0.3 : 0), width: 3),
            boxShadow: d.available
                ? [BoxShadow(color: d.color.withOpacity(0.4), blurRadius: 14, offset: const Offset(0, 6))]
                : EduTheme.softShadow(),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(color: (d.available ? Colors.white : Colors.grey).withOpacity(0.2), borderRadius: BorderRadius.circular(18)),
                      child: Center(child: Text(d.emoji, style: const TextStyle(fontSize: 28))),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: d.available ? Colors.white : EduTheme.textLight)),
                        const SizedBox(height: 4),
                        Text(d.subtitle, style: TextStyle(fontSize: 11, height: 1.4, color: d.available ? Colors.white70 : EduTheme.textLight)),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 12, right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: (d.available ? Colors.white : Colors.grey).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: Text(d.available ? "Mulai ▶" : "🔒", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: d.available ? Colors.white : EduTheme.textLight)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
