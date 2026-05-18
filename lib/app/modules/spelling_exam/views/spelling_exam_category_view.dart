import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SpellingExamCategoryView extends StatelessWidget {
  const SpellingExamCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      _ExamCategoryData(
        emoji: '🔠',
        title: 'Huruf Kapital',
        subtitle: 'A B C D E F ...',
        gradient: [const Color(0xFFFF9800), const Color(0xFFFFC107)],
        available: true,
        categoryKey: 'capital',
      ),

      _ExamCategoryData(
        emoji: '🔡',
        title: 'Huruf Kecil',
        subtitle: 'a b c d e f ...',
        gradient: [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
        available: false,
        categoryKey: 'lowercase',
      ),

      _ExamCategoryData(
        emoji: '🕌',
        title: 'Huruf Hijaiyah',
        subtitle: 'ا ب ت ث ...',
        gradient: [const Color(0xFF9D4EDD), const Color(0xFFC77DFF)],
        available: false,
        categoryKey: 'hijaiyah',
      ),

      _ExamCategoryData(
        emoji: '🔢',
        title: 'Angka',
        subtitle: '1 2 3 4 5 ...',
        gradient: [const Color(0xFFFF758C), const Color(0xFFFF7EB3)],
        available: false,
        categoryKey: 'number',
      ),

      _ExamCategoryData(
        emoji: '🧩',
        title: 'Kata Mudah',
        subtitle: 'Bola, Buku ...',
        gradient: [const Color(0xFF7F7FD5), const Color(0xFF86A8E7)],
        available: true,
        categoryKey: 'word',
      ),

      _ExamCategoryData(
        emoji: '🎧',
        title: 'Tebak Suara',
        subtitle: 'Dengar & Jawab',
        gradient: [const Color(0xFF00C9A7), const Color(0xFF92FE9D)],
        available: false,
        categoryKey: 'sound',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EC),

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.95,
                ),

                itemCount: categories.length,

                itemBuilder: (ctx, i) {
                  final cat = categories[i];

                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),

                    duration: Duration(milliseconds: 350 + i * 90),

                    curve: Curves.easeOutBack,

                    builder: (_, v, child) =>
                        Transform.scale(scale: v, child: child),

                    child: _ExamCategoryCard(data: cat),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 20, 24),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFFC107)],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),

        boxShadow: [
          BoxShadow(
            color: Color(0x44FF9800),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 22,
                ),

                onPressed: () => Get.back(),
              ),

              const Expanded(
                child: Text(
                  'Ujian Mengeja 🔤',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(22),
            ),

            child: Row(
              children: [
                const Text('🎓', style: TextStyle(fontSize: 38)),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: const [
                      Text(
                        'Pilih kategori ujian!',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 3),

                      Text(
                        'Uji kemampuan mengeja kamu 😊',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xCCFFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamCategoryData {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final bool available;
  final String categoryKey;

  const _ExamCategoryData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.available,
    required this.categoryKey,
  });
}

class _ExamCategoryCard extends StatefulWidget {
  final _ExamCategoryData data;

  const _ExamCategoryCard({required this.data});

  @override
  State<_ExamCategoryCard> createState() => _ExamCategoryCardState();
}

class _ExamCategoryCardState extends State<_ExamCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _scale = Tween<double>(begin: 1.0, end: 0.93).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.data.available) {
      Get.snackbar(
        'Segera Hadir! 🚀',
        '${widget.data.title} akan segera tersedia!',

        snackPosition: SnackPosition.BOTTOM,

        backgroundColor: const Color(0xFFFF9800).withOpacity(0.92),

        colorText: Colors.white,

        borderRadius: 20,

        margin: const EdgeInsets.all(16),

        icon: const Icon(Icons.hourglass_top_rounded, color: Colors.white),

        duration: const Duration(seconds: 2),
      );

      return;
    }

    Get.toNamed(
      Routes.SPELLING_EXAM,

      arguments: {
        'category': widget.data.categoryKey,
        'title': widget.data.title,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),

      onTapUp: (_) {
        _ctrl.reverse();
        _handleTap();
      },

      onTapCancel: () => _ctrl.reverse(),

      child: AnimatedBuilder(
        animation: _scale,

        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),

        child: Container(
          decoration: BoxDecoration(
            gradient: d.available
                ? LinearGradient(
                    colors: d.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,

            color: d.available ? null : const Color(0xFFECECF4),

            borderRadius: BorderRadius.circular(26),

            boxShadow: [
              BoxShadow(
                color: d.available
                    ? d.gradient.last.withOpacity(0.4)
                    : Colors.grey.withOpacity(0.1),

                blurRadius: d.available ? 16 : 6,

                offset: const Offset(0, 7),
              ),
            ],
          ),

          child: Stack(
            children: [
              if (d.available)
                Positioned(
                  top: -20,
                  right: -20,

                  child: Container(
                    width: 90,
                    height: 90,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Container(
                      width: 54,
                      height: 54,

                      decoration: BoxDecoration(
                        color: d.available
                            ? Colors.white.withOpacity(0.22)
                            : Colors.grey.withOpacity(0.13),

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
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: d.available
                                ? Colors.white
                                : const Color(0xFF9090A0),
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          d.subtitle,

                          style: TextStyle(
                            fontSize: 10,
                            color: d.available
                                ? Colors.white70
                                : const Color(0xFFB0B0C0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (!d.available)
                Positioned(
                  top: 10,
                  right: 10,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xFF9090A0).withOpacity(0.12),

                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: const Text(
                      'Coming Soon',

                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF9090A0),
                      ),
                    ),
                  ),
                ),

              if (d.available)
                Positioned(
                  bottom: 12,
                  right: 12,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.28),

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: const Text(
                      'Mulai ▶',

                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
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
