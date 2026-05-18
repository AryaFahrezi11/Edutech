import 'package:edutech/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpellingCategoryView extends StatelessWidget {
  const SpellingCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      _CategoryData(
        emoji: "🔤",
        title: "Huruf A - Z",
        subtitle: "A a • B b • C c ...",
        gradient: [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
        available: true,
      ),

      _CategoryData(
        emoji: "🕌",
        title: "Huruf Hijaiyah",
        subtitle: "ا ب ت ث ...",
        gradient: [const Color(0xFFFFB75E), const Color(0xFFED8F03)],
        available: false,
      ),

      _CategoryData(
        emoji: "🔢",
        title: "Angka",
        subtitle: "1 2 3 4 5 ...",
        gradient: [const Color(0xFFFF758C), const Color(0xFFFF7EB3)],
        available: false,
      ),

      _CategoryData(
        emoji: "🧩",
        title: "Kata Mudah",
        subtitle: "Bola, Buku ...",
        gradient: [const Color(0xFF7F7FD5), const Color(0xFF86A8E7)],
        available: false,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FF),

      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.fromLTRB(8, 12, 20, 20),

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),

              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),

                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),

                      const Expanded(
                        child: Text(
                          "Latihan Mengeja 🔤",

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(22),
                    ),

                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Belajar Huruf Dengan Seru ✨",

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          "Pilih kategori lalu mulai belajar huruf A sampai Z",

                          style: TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // GRID
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),

                child: GridView.builder(
                  itemCount: categories.length,

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.0,
                  ),

                  itemBuilder: (context, index) {
                    final category = categories[index];

                    return _CategoryCard(data: category);
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

// MODEL
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

// CARD
class _CategoryCard extends StatefulWidget {
  final _CategoryData data;

  const _CategoryCard({required this.data});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0,
      upperBound: 0.04,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.data.available) {
      Get.snackbar(
        "Coming Soon 🚀",
        "${widget.data.title} akan segera tersedia",

        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4FACFE),
        colorText: Colors.white,
      );

      return;
    }

    Get.toNamed(Routes.SPELLING_PRACTICE);
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),

      onTapUp: (_) {
        _controller.reverse();
        _handleTap();
      },

      onTapCancel: () => _controller.reverse(),

      child: AnimatedBuilder(
        animation: _scaleAnimation,

        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },

        child: Container(
          decoration: BoxDecoration(
            gradient: d.available
                ? LinearGradient(
                    colors: d.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,

            color: d.available ? null : const Color(0xFFE8E8F0),

            borderRadius: BorderRadius.circular(26),

            boxShadow: [
              BoxShadow(
                color: d.available
                    ? d.gradient.last.withOpacity(0.28)
                    : Colors.grey.withOpacity(0.12),

                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
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
                      width: 56,
                      height: 56,

                      decoration: BoxDecoration(
                        color: d.available
                            ? Colors.white.withOpacity(0.22)
                            : Colors.grey.withOpacity(0.15),

                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: Center(
                        child: Text(
                          d.emoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          d.title,

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,

                            color: d.available
                                ? Colors.white
                                : const Color(0xFF9090A0),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          d.subtitle,

                          style: TextStyle(
                            fontSize: 11,
                            height: 1.4,

                            color: d.available
                                ? Colors.white70
                                : const Color(0xFFAAAAAA),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // BADGE
              Positioned(
                bottom: 12,
                right: 12,

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: d.available
                        ? Colors.white.withOpacity(0.22)
                        : Colors.grey.withOpacity(0.2),

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Text(
                    d.available ? "Mulai ▶" : "Soon",

                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,

                      color: d.available
                          ? Colors.white
                          : const Color(0xFF9090A0),
                    ),
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
