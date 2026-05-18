import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/writing_exam_controller.dart';
import 'dart:math' as math;

class WritingExamView extends GetView<WritingExamController> {
  const WritingExamView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: SafeArea(
        child: Obx(() {
          switch (controller.examState.value) {
            case ExamState.idle:
              return _buildIdleScreen();
            case ExamState.countdown:
              return _buildCountdownScreen();
            case ExamState.drawing:
              return _buildDrawingScreen();
            case ExamState.checking:
              return _buildCheckingScreen();
            case ExamState.result:
              return _buildResultScreen();
          }
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 1. IDLE SCREEN – Layar selamat datang sebelum ujian
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildIdleScreen() {
    return Column(
      children: [
        // Header
        _buildHeader(showProgress: false),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Maskot besar
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (_, v, child) => Transform.scale(scale: v, child: child),
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF9F1C).withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: const Center(
                      child: Text('✏️', style: TextStyle(fontSize: 80)),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Ujian Menulis',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF3A2F6B),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Kamu akan diminta menulis beberapa huruf.\nTulis sebaik mungkin ya! 😊',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Color(0xFF7B7B9A), height: 1.5),
                ),
                const SizedBox(height: 32),
                // Info soal
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _infoChip('📝', '${controller.questions.length}', 'Soal'),
                      _divider(),
                      _infoChip('⏱️', '∞', 'Waktu'),
                      _divider(),
                      _infoChip('⭐', '100', 'Nilai Max'),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                // Tombol Mulai
                GestureDetector(
                  onTap: controller.startExam,
                  child: Container(
                    width: double.infinity,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF9F1C), Color(0xFFFFD166)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF9F1C).withOpacity(0.5),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🚀', style: TextStyle(fontSize: 26)),
                        SizedBox(width: 12),
                        Text(
                          'Mulai Ujian!',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Tombol Kembali
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(color: Color(0xFF9090A0), fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 2. COUNTDOWN SCREEN
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildCountdownScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Bersiap!',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF3A2F6B)),
          ),
          const SizedBox(height: 30),
          Obx(() => TweenAnimationBuilder<double>(
                key: ValueKey(controller.countdown.value),
                tween: Tween(begin: 1.5, end: 1.0),
                duration: const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                builder: (_, v, child) => Transform.scale(scale: v, child: child),
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${controller.countdown.value}',
                      style: const TextStyle(
                          fontSize: 72, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 30),
          Obx(() => Text(
                'Soal ${controller.currentLetterIndex.value + 1} dari ${controller.questions.length}',
                style: const TextStyle(fontSize: 16, color: Color(0xFF9090A0)),
              )),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 3. DRAWING SCREEN – Area menulis huruf
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildDrawingScreen() {
    final q = controller.currentQuestion;
    return Column(
      children: [
        _buildHeader(showProgress: true),
        const SizedBox(height: 12),
        // Kartu Pertanyaan
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Row(
              children: [
                Text(q['emoji'], style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tulis huruf ini:',
                          style: TextStyle(fontSize: 12, color: Color(0xFF9090A0))),
                      const SizedBox(height: 2),
                      Text(
                        'Huruf ${q['letter']}',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF3A2F6B)),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF48C6EF)]),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      q['letter'],
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Kanvas Tulis
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4FD),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Stack(
                  children: [
                    // Background garis
                    CustomPaint(
                      painter: _ExamStripesPainter(),
                      child: const SizedBox.expand(),
                    ),
                    // Hint huruf samar di tengah
                    Center(
                      child: Text(
                        q['letter'],
                        style: TextStyle(
                          fontSize: 220,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF6C63FF).withOpacity(0.06),
                          height: 1,
                        ),
                      ),
                    ),
                    // Tulisan anak
                    GestureDetector(
                      onPanUpdate: controller.onPanUpdate,
                      onPanEnd: (_) => controller.onPanEnd(),
                      child: Obx(() => CustomPaint(
                            painter: _ExamCanvasPainter(
                                points: controller.userPoints.toList()),
                            child: const SizedBox.expand(),
                          )),
                    ),
                    // Tombol hapus (pojok kanan atas)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: controller.resetCanvas,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                              )
                            ],
                          ),
                          child: const Text('🗑️', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        // Tombol Kirim
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: controller.submitAnswer,
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF11998E).withOpacity(0.45),
                    blurRadius: 16,
                    offset: const Offset(0, 7),
                  )
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('✅', style: TextStyle(fontSize: 22)),
                  SizedBox(width: 10),
                  Text(
                    'Kirim Jawaban',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 4. CHECKING SCREEN – Animasi AI memeriksa
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildCheckingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _SpinningLoader(),
          const SizedBox(height: 24),
          const Text(
            'AI sedang memeriksa...',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF3A2F6B)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tunggu sebentar ya! 🤖',
            style: TextStyle(fontSize: 14, color: Color(0xFF9090A0)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 5. RESULT SCREEN – Hasil per soal
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildResultScreen() {
    final isOk = controller.isCorrect.value;
    return Column(
      children: [
        _buildHeader(showProgress: true),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animasi bintang / gagal
                ScaleTransition(
                  scale: controller.starsAnim,
                  child: Text(
                    isOk ? '🌟' : '💪',
                    style: const TextStyle(fontSize: 100),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isOk ? 'Benar! Hebat! 🎉' : 'Hampir Benar! Yuk Coba Lagi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: isOk ? const Color(0xFF11998E) : const Color(0xFFFF6B6B),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isOk
                      ? 'Kamu menulis huruf "${controller.currentQuestion['letter']}" dengan bagus!'
                      : 'Latihan lagi ya, kamu pasti bisa!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Color(0xFF9090A0), height: 1.5),
                ),
                const SizedBox(height: 28),
                // Nilai soal ini
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('⭐ Total Nilai: ',
                          style: TextStyle(fontSize: 16, color: Color(0xFF7B7B9A))),
                      Obx(() => Text(
                            '${controller.score.value}',
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF3A2F6B)),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: controller.nextQuestion,
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: controller.isLastQuestion
                            ? [const Color(0xFFFF6B6B), const Color(0xFFFF9F1C)]
                            : [const Color(0xFF6C63FF), const Color(0xFF48C6EF)],
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 7),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.isLastQuestion ? '🏁 Selesai' : '➡️ Soal Berikutnya',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SHARED WIDGETS
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHeader({required bool showProgress}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 20, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF9F1C), Color(0xFFFFD166)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Color(0x44FF9F1C),
            blurRadius: 14,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
                onPressed: () => Get.back(),
              ),
              const Expanded(
                child: Text(
                  '✏️ Ujian Menulis',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
              Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '⭐ ${controller.score.value}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16),
                    ),
                  )),
            ],
          ),
          if (showProgress) ...[
            const SizedBox(height: 10),
            Obx(() {
              final progress = (controller.currentLetterIndex.value + 1) /
                  controller.questions.length;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Soal ${controller.currentLetterIndex.value + 1} dari ${controller.questions.length}',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                      minHeight: 8,
                    ),
                  ),
                ],
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _infoChip(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF3A2F6B))),
        Text(label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF9090A0))),
      ],
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 50, color: const Color(0xFFEEEEF5));
  }
}

// ─── CANVAS PAINTER ───────────────────────────────────────────────────────────
class _ExamCanvasPainter extends CustomPainter {
  final List<Offset?> points;
  _ExamCanvasPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6C63FF)
      ..strokeWidth = 18.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    Path path = Path();
    bool newSubpath = true;
    for (final p in points) {
      if (p == null) {
        newSubpath = true;
      } else {
        if (newSubpath) {
          path.moveTo(p.dx, p.dy);
          newSubpath = false;
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ExamCanvasPainter old) => old.points != points;
}

// ─── STRIPES BACKGROUND ───────────────────────────────────────────────────────
class _ExamStripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2.5;
    const spacing = 50.0;
    for (double y = spacing; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── SPINNING LOADER ──────────────────────────────────────────────────────────
class _SpinningLoader extends StatefulWidget {
  const _SpinningLoader();
  @override
  State<_SpinningLoader> createState() => _SpinningLoaderState();
}

class _SpinningLoaderState extends State<_SpinningLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Transform.rotate(
        angle: _ctrl.value * 2 * math.pi,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: const SweepGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF48C6EF), Colors.transparent],
            ),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: CircleAvatar(
              radius: 38,
              backgroundColor: Color(0xFFF0F4FF),
              child: Text('🤖', style: TextStyle(fontSize: 36)),
            ),
          ),
        ),
      ),
    );
  }
}
