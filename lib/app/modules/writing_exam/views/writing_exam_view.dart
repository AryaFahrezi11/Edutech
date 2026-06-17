import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/writing_exam_controller.dart';
import 'dart:math' as math;

class WritingExamView extends GetView<WritingExamController> {
  const WritingExamView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Obx(() {
          switch (controller.examState.value) {
            case ExamState.idle:
              return _buildIdleScreen(context);
            case ExamState.countdown:
              return _buildCountdownScreen();
            case ExamState.drawing:
              return _buildDrawingScreen(context); // Lempar context untuk deteksi orientasi layar
            case ExamState.checking:
              return _buildCheckingScreen();
            case ExamState.result:
              return _buildResultScreen(context);
          }
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 1. IDLE SCREEN
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildIdleScreen(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context: context, showProgress: false),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (_, v, child) => Transform.scale(scale: v, child: child),
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: const Color(0xFFFF9F1C).withOpacity(0.3), blurRadius: 30, spreadRadius: 5)
                      ],
                    ),
                    child: const Center(child: Text('✏️', style: TextStyle(fontSize: 70))),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Ujian ${controller.categoryTitle.value}',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF3A2F6B)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tuliskan dengan rapi tanpa garis panduan ya! 😊',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Color(0xFF7B7B9A), height: 1.5),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _infoChip('📝', '${controller.questions.length}', 'Soal'),
                      _divider(),
                      _infoChip('⏱️', '∞', 'Waktu'),
                      _divider(),
                      _infoChip('⭐', '${controller.questions.length * 20}', 'Max'),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: controller.startExam,
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)]),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: const Color(0xFFFF9F1C).withOpacity(0.5), blurRadius: 18, offset: const Offset(0, 8))],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🚀', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 12),
                        Text('Mulai Ujian!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Kembali ke Beranda', style: TextStyle(color: Color(0xFF9090A0), fontSize: 14)),
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
          const Text('Bersiap!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF3A2F6B))),
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
                    gradient: const LinearGradient(colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)]),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: const Color(0xFF1CB0F6).withOpacity(0.4), blurRadius: 30, spreadRadius: 5)],
                  ),
                  child: Center(
                    child: Text('${controller.countdown.value}',
                        style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w900, color: Colors.white)),
                  ),
                ),
              )),
          const SizedBox(height: 30),
          Obx(() => Text('Soal ${controller.currentLetterIndex.value + 1} dari ${controller.questions.length}',
              style: const TextStyle(fontSize: 16, color: Color(0xFF9090A0)))),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 3. DRAWING SCREEN – Dibuat Responsif (Portrait vs Landscape)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildDrawingScreen(BuildContext context) {
    final q = controller.currentQuestion;
    // Deteksi apakah layar sedang tidur (Landscape) atau berdiri (Portrait)
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Column(
      children: [
        _buildHeader(context: context, showProgress: true),
        const SizedBox(height: 12),
        
        Expanded(
          child: isLandscape
              // TAMPILAN LANSKAP: Kiri (Soal & Tombol) | Kanan (Canvas Lebar)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Kolom Kiri
                    Container(
                      width: 260, // Lebar area tombol di kiri
                      padding: const EdgeInsets.only(left: 20, right: 10, bottom: 12),
                      child: Column(
                        children: [
                          _buildHintCard(q, isLandscape: true),
                          const Spacer(),
                          _buildBottomControls(),
                        ],
                      ),
                    ),
                    // Kolom Kanan (Canvas)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, bottom: 12),
                        child: _buildCanvasArea(q),
                      ),
                    ),
                  ],
                )
              // TAMPILAN PORTRAIT: Atas ke Bawah seperti biasa
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildHintCard(q, isLandscape: false),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildCanvasArea(q),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: _buildBottomControls(),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
        ),
      ],
    );
  }

  // Komponen Kartu Soal
  Widget _buildHintCard(Map<String, dynamic> q, {required bool isLandscape}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Text(q['emoji'], style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tulis:', style: TextStyle(fontSize: 11, color: Color(0xFF9090A0))),
                Text(
                  q['letter'],
                  style: TextStyle(
                    fontSize: isLandscape ? 18 : 22, 
                    fontWeight: FontWeight.w900, 
                    color: const Color(0xFF3A2F6B)
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  q['hint'],
                  style: const TextStyle(fontSize: 11, color: Colors.black54, fontStyle: FontStyle.italic),
                  maxLines: isLandscape ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Komponen Kanvas Menulis
  Widget _buildCanvasArea(Map<String, dynamic> q) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4FD),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 3),
        boxShadow: [BoxShadow(color: const Color(0xFF6C63FF).withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background garis buku
            CustomPaint(painter: _ExamStripesPainter(), child: const SizedBox.expand()),
            
            // Hint huruf samar di tengah (Pakai FittedBox agar kata "Kucing" mengecil otomatis)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    q['letter'],
                    style: TextStyle(
                      fontSize: 300, // Ukuran maksimal
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF6C63FF).withOpacity(0.06),
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
            
            // Tulisan anak (Kanvas Transparan)
            GestureDetector(
              onPanUpdate: controller.onPanUpdate,
              onPanEnd: (_) => controller.onPanEnd(),
              child: Obx(() => CustomPaint(
                    size: Size.infinite,
                    painter: _ExamCanvasPainter(points: controller.userPoints.toList()),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  // Komponen Tombol Hapus & Kirim
  Widget _buildBottomControls() {
    return Row(
      children: [
        // Tombol Hapus
        GestureDetector(
          onTap: controller.resetCanvas,
          child: Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFF6B6B).withOpacity(0.3), width: 2),
            ),
            child: const Center(child: Text("🗑️", style: TextStyle(fontSize: 22))),
          ),
        ),
        const SizedBox(width: 12),
        // Tombol Kirim
        Expanded(
          child: GestureDetector(
            onTap: controller.submitAnswer,
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: const Color(0xFF11998E).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("✅", style: TextStyle(fontSize: 18)),
                  SizedBox(width: 8),
                  Text("Selesai", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 4. CHECKING SCREEN
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildCheckingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _SpinningLoader(),
          SizedBox(height: 24),
          Text('AI sedang memeriksa...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF3A2F6B))),
          SizedBox(height: 8),
          Text('Tunggu sebentar ya! 🤖', style: TextStyle(fontSize: 14, color: Color(0xFF9090A0))),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 5. RESULT SCREEN
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildResultScreen(BuildContext context) {
    final isOk = controller.isCorrect.value;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Column(
      children: [
        _buildHeader(context: context, showProgress: true),
        Expanded(
          // KUNCI PERBAIKAN: SingleChildScrollView mencegah overflow kuning-hitam!
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: controller.starsAnim,
                  child: Text(
                    isOk ? '🌟' : '💪', 
                    // Ukuran bintang dikecilkan jika mode lanskap
                    style: TextStyle(fontSize: isLandscape ? 60 : 100), 
                  ),
                ),
                SizedBox(height: isLandscape ? 8 : 16),
                Text(
                  isOk ? 'Benar! Hebat! 🎉' : 'Hampir Benar! Yuk Coba Lagi',
                  style: TextStyle(
                    fontSize: isLandscape ? 20 : 24,
                    fontWeight: FontWeight.w900,
                    color: isOk ? const Color(0xFF11998E) : const Color(0xFFFF6B6B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isOk 
                      ? 'Kamu menulis "${controller.currentQuestion['letter']}" dengan rapi!' 
                      : 'Latihan lagi ya, kamu pasti bisa!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Color(0xFF9090A0), height: 1.4),
                ),
                SizedBox(height: isLandscape ? 16 : 28),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 6))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min, // Agar kotaknya tidak terlalu melar
                    children: [
                      const Text('⭐ Total Nilai: ', style: TextStyle(fontSize: 16, color: Color(0xFF7B7B9A))),
                      Obx(() => Text('${controller.score.value}',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF3A2F6B)))),
                    ],
                  ),
                ),
                SizedBox(height: isLandscape ? 16 : 32),
                GestureDetector(
                  onTap: controller.nextQuestion,
                  child: Container(
                    width: isLandscape ? 280 : double.infinity, // Tombol tidak full-width di lanskap
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: controller.isLastQuestion 
                            ? [const Color(0xFFFF6B6B), const Color(0xFFFF9F1C)] 
                            : [const Color(0xFF1CB0F6), const Color(0xFF1899D6)],
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [BoxShadow(color: const Color(0xFF1CB0F6).withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 7))],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(controller.isLastQuestion ? '🏁 Selesai' : '➡️ Soal Berikutnya',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
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
  Widget _buildHeader({required BuildContext context, required bool showProgress}) {
    // Mengecilkan header jika dalam mode landscape agar hemat tempat
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    return Container(
      padding: EdgeInsets.fromLTRB(16, isLandscape ? 4 : 12, 20, isLandscape ? 8 : 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
                onPressed: () => Get.back(),
              ),
              Expanded(
                child: Text('✏️ Ujian', style: TextStyle(fontSize: isLandscape ? 16 : 20, fontWeight: FontWeight.w900, color: Colors.white)),
              ),
              Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(16)),
                    child: Text('⭐ ${controller.score.value}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
                  )),
            ],
          ),
          if (showProgress) ...[
            SizedBox(height: isLandscape ? 4 : 10),
            Obx(() {
              final progress = (controller.currentLetterIndex.value + 1) / controller.questions.length;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Soal ${controller.currentLetterIndex.value + 1}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      Text('${(progress * 100).round()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                      minHeight: 6,
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
        Text(icon, style: const TextStyle(fontSize: 24)),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF3A2F6B))),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF9090A0))),
      ],
    );
  }

  Widget _divider() => Container(width: 1, height: 40, color: const Color(0xFFEEEEF5));
}

// ─── CANVAS PAINTER ───────────────────────────────────────────────────────────
class _ExamCanvasPainter extends CustomPainter {
  final List<Offset?> points;
  _ExamCanvasPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6C63FF)
      ..strokeWidth = 14.0 // Sedikit lebih tipis dari latihan karena areanya lebih bebas
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

class _SpinningLoaderState extends State<_SpinningLoader> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
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
          decoration: const BoxDecoration(
            gradient: SweepGradient(colors: [Color(0xFF1CB0F6), Color(0xFF1899D6), Colors.transparent]),
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