import 'package:flutter/material.dart' hide Ink;
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart' hide Stroke;
import 'package:lottie/lottie.dart';
import '../../../services/tts_service.dart';
import '../controllers/writing_exam_controller.dart';

class WritingExamView extends GetView<WritingExamController> {
  const WritingExamView({Key? key}) : super(key: key);

  // Warna konsisten dengan tema aplikasi
  static const _primaryBlue = Color(0xFF1CB0F6);
  static const _darkBlue = Color(0xFF1899D6);
  static const _bgLight = Color(0xFFF0F7FF);
  static const _inkPurple = Color(0xFF6C63FF);
  static const _textDark = Color(0xFF3A2F6B);
  static const _textMuted = Color(0xFF9090A0);
  static const _successGreen = Color(0xFF11998E);
  static const _errorRed = Color(0xFFFF6B6B);
  static const _gold = Color(0xFFFFD166);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      body: SafeArea(
        child: Stack(
          children: [
            // Konten Utama
            Positioned.fill(
              child: Obx(() {
                switch (controller.examState.value) {
                  case ExamState.idle:
                    return _buildIdleScreen(context);
                  case ExamState.drawing:
                  case ExamState.evaluating:
                    return _buildDrawingScreen(context);
                  case ExamState.checking:
                    return _buildCheckingScreen();
                  case ExamState.result:
                    return _buildResultScreen(context);
                }
              }),
            ),
            
            // AI Teacher Overlay (Menganalisa & Evaluasi)
            Obx(() {
              final isEvaluating = controller.examState.value == ExamState.evaluating;
              
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                top: isEvaluating ? 60 : -400, // Muncul dari atas ke tengah-atas
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: isEvaluating ? 1.0 : 0.0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: Lottie.asset(
                        'assets/lotties/owl.json',
                        height: 180,
                        fit: BoxFit.contain,
                        animate: true,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 1. IDLE / WELCOME SCREEN
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildIdleScreen(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context: context, showProgress: false),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Maskot
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (_, v, child) => Transform.scale(scale: v, child: child),
                  child: const _BouncingEmoji(emoji: '✏️', size: 80),
                ),
                const SizedBox(height: 16),

                // Judul
                Obx(() => Text(
                  'Ujian ${controller.categoryTitle.value}',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: _textDark),
                  textAlign: TextAlign.center,
                )),
                const SizedBox(height: 8),
                const Text(
                  'Tuliskan dengan rapi ya! Kamu pasti bisa! 😊',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: _textMuted, height: 1.5),
                ),
                const SizedBox(height: 24),

                // Info Misi
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: _primaryBlue.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _infoChip('📝', '${controller.totalQuestions}', 'Soal'),
                      Container(width: 1, height: 40, color: const Color(0xFFEEEEF5)),
                      _infoChip('⏱️', '∞', 'Waktu'),
                      Container(width: 1, height: 40, color: const Color(0xFFEEEEF5)),
                      _infoChip('⭐', '${controller.totalQuestions * 20}', 'Max'),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Tombol Mulai (3D style, warna tema biru)
                GestureDetector(
                  onTap: controller.startExam,
                  child: Container(
                    width: double.infinity,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [_primaryBlue, _darkBlue]),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(color: _primaryBlue.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4)),
                        const BoxShadow(color: Color(0xFF1480B0), blurRadius: 0, offset: Offset(0, 5)),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🚀', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 12),
                        Text('Mulai Misi!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('← Kembali', style: TextStyle(color: _textMuted, fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. DRAWING SCREEN
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildDrawingScreen(BuildContext context) {
    final q = controller.currentQuestion;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Column(
      children: [
        _buildHeader(context: context, showProgress: true),
        
        Expanded(
          child: isLandscape
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 260,
                      padding: const EdgeInsets.only(left: 16, right: 8, bottom: 12),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          _buildHintCard(q, isLandscape: true),
                          const Spacer(),
                          _buildGameButtons(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16, bottom: 12, top: 8),
                        child: _buildCanvasArea(q),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildHintCard(q, isLandscape: false),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildCanvasArea(q),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: _buildGameButtons(),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
        ),
      ],
    );
  }

  // Kartu Soal (animasi pop-in tiap ganti soal)
  Widget _buildHintCard(Map<String, dynamic> q, {required bool isLandscape}) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(controller.currentLetterIndex.value),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      builder: (_, v, child) => Transform.scale(scale: v.clamp(0.0, 1.0), child: Opacity(opacity: v.clamp(0.0, 1.0), child: child)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: _primaryBlue.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 5))],
          border: Border.all(color: _primaryBlue.withOpacity(0.1), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _primaryBlue.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Center(child: Text(q['emoji'], style: const TextStyle(fontSize: 28))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('✏️ Tulis:', style: TextStyle(fontSize: 11, color: _textMuted, fontWeight: FontWeight.w600)),
                  Text(
                    q['letter'],
                    style: TextStyle(
                      fontSize: isLandscape ? 20 : 26,
                      fontWeight: FontWeight.w900,
                      color: _textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    q['hint'],
                    style: const TextStyle(fontSize: 11, color: _textMuted, fontStyle: FontStyle.italic),
                    maxLines: isLandscape ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Kanvas Menulis (clean, buku tulis)
  Widget _buildCanvasArea(Map<String, dynamic> q) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 2.5),
        boxShadow: [BoxShadow(color: _primaryBlue.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            // Background garis buku tulis
            CustomPaint(painter: _NotebookLinesPainter(), child: const SizedBox.expand()),

            // Hint huruf samar di tengah
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    q['letter'],
                    style: TextStyle(
                      fontSize: 300,
                      fontWeight: FontWeight.w900,
                      color: _inkPurple.withOpacity(0.06),
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),

            // Canvas tempat anak menggambar (di-block jika sedang evaluasi/checking)
            Obx(() => AbsorbPointer(
              absorbing: controller.examState.value == ExamState.evaluating || 
                         controller.examState.value == ExamState.checking,
              child: GestureDetector(
                onPanStart: controller.onPanStart,
                onPanUpdate: controller.onPanUpdate,
                onPanEnd: (_) => controller.onPanEnd(),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _ExamCanvasPainter(points: controller.userPoints.toList()),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  // Tombol bergaya game 3D (tapi warna tetap selaras)
  Widget _buildGameButtons() {
    return Obx(() {
      final isBusy = controller.examState.value == ExamState.evaluating || 
                     controller.examState.value == ExamState.checking;
                     
      if (isBusy) {
        return const SizedBox(height: 60); // Jaga ruang tetap sama agar layout tidak loncat
      }

      return Row(
        children: [
          // Tombol Hapus
          GestureDetector(
            onTap: controller.resetCanvas,
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_errorRed, Color(0xFFEE5253)]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: _errorRed.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3)),
                  const BoxShadow(color: Color(0xFFCC4444), blurRadius: 0, offset: Offset(0, 4)),
                ],
              ),
              child: const Center(child: Text("🗑️", style: TextStyle(fontSize: 24))),
            ),
          ),
          const SizedBox(width: 14),
          // Tombol Kirim
          Expanded(
            child: GestureDetector(
              onTap: controller.submitAnswer,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [_successGreen, Color(0xFF38EF7D)]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: _successGreen.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3)),
                    const BoxShadow(color: Color(0xFF0D7D6C), blurRadius: 0, offset: Offset(0, 4)),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("✅", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 10),
                    Text("Selesai!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. CHECKING SCREEN
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildCheckingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _BouncingEmoji(emoji: '🤖', size: 80),
          const SizedBox(height: 20),
          const Text('AI sedang memeriksa...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _textDark)),
          const SizedBox(height: 8),
          const Text('Tunggu sebentar ya! 🔍', style: TextStyle(fontSize: 14, color: _textMuted)),
          const SizedBox(height: 24),
          SizedBox(
            width: 180,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                minHeight: 8,
                backgroundColor: Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation(_primaryBlue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 4. RESULT SCREEN
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildResultScreen(BuildContext context) {
    final isOk = controller.isCorrect.value;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Column(
      children: [
        _buildHeader(context: context, showProgress: true),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: isLandscape ? 12 : 20),
            child: Column(
              children: [
                // Emoji reaksi
                ScaleTransition(
                  scale: controller.starsAnim,
                  child: Text(
                    isOk ? '🌟' : '💪',
                    style: TextStyle(fontSize: isLandscape ? 60 : 90),
                  ),
                ),
                SizedBox(height: isLandscape ? 8 : 14),
                Text(
                  isOk ? 'Benar! Hebat! 🎉' : 'Hampir Benar! Yuk Coba Lagi',
                  style: TextStyle(
                    fontSize: isLandscape ? 20 : 24,
                    fontWeight: FontWeight.w900,
                    color: isOk ? _successGreen : _errorRed,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isOk
                      ? 'Kamu menulis "${controller.currentQuestion['letter']}" dengan rapi!'
                      : 'Latihan lagi ya, kamu pasti bisa!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: _textMuted, height: 1.4),
                ),
                SizedBox(height: isLandscape ? 14 : 24),

                // Badge skor
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, 6))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('⭐ Skor: ', style: TextStyle(fontSize: 16, color: _textMuted)),
                      Obx(() => Text('${controller.score.value}',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: _textDark))),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Tombol Aksi (Lanjut / Kembali / Coba Lagi)
                if (isOk)
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: controller.backToMenu,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: _primaryBlue.withOpacity(0.2), width: 2),
                            ),
                            child: const Center(
                              child: Text('Kembali', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _primaryBlue)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: controller.goToNextLevel,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [_primaryBlue, _darkBlue]),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: _primaryBlue.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3)),
                                const BoxShadow(color: Color(0xFF1480B0), blurRadius: 0, offset: Offset(0, 4)),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Lanjut', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                                SizedBox(width: 8),
                                Text('🚀', style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: controller.backToMenu,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: _errorRed.withOpacity(0.2), width: 2),
                            ),
                            child: const Center(
                              child: Text('Kembali', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _errorRed)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: controller.retryLevel,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [_gold, Color(0xFFF39C12)]),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: _gold.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3)),
                                const BoxShadow(color: Color(0xFFD68910), blurRadius: 0, offset: Offset(0, 4)),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Coba Lagi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                                SizedBox(width: 8),
                                Text('🔄', style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SHARED WIDGETS
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildHeader({required BuildContext context, required bool showProgress}) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      padding: EdgeInsets.fromLTRB(12, isLandscape ? 4 : 8, 16, isLandscape ? 8 : 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_primaryBlue, _darkBlue]),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
        boxShadow: [BoxShadow(color: _primaryBlue.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Obx(() {
                final isBusy = controller.examState.value == ExamState.evaluating || 
                               controller.examState.value == ExamState.checking;
                return GestureDetector(
                  onTap: isBusy ? null : () => Get.back(),
                  child: Opacity(
                    opacity: isBusy ? 0.5 : 1.0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 12),
              Expanded(
                child: Text('✏️ Ujian Menulis', style: TextStyle(fontSize: isLandscape ? 16 : 18, fontWeight: FontWeight.w900, color: Colors.white)),
              ),
              // Skor
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('⭐', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text('${controller.score.value}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
                  ],
                ),
              )),
            ],
          ),
          if (showProgress) ...[
            SizedBox(height: isLandscape ? 4 : 10),
            // Progress bar segmented
            Obx(() {
              return Row(
                children: List.generate(controller.totalQuestions, (i) {
                  final isCurrent = i == controller.currentLetterIndex.value;
                  final isDone = i < controller.currentLetterIndex.value;
                  return Expanded(
                    child: Container(
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: isDone
                            ? _gold
                            : isCurrent
                                ? Colors.white
                                : Colors.white.withOpacity(0.25),
                      ),
                    ),
                  );
                }),
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
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _textDark)),
        Text(label, style: const TextStyle(fontSize: 11, color: _textMuted)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// BOUNCING EMOJI – Animasi naik-turun halus
// ═══════════════════════════════════════════════════════════════════════════════
class _BouncingEmoji extends StatefulWidget {
  final String emoji;
  final double size;
  const _BouncingEmoji({required this.emoji, required this.size});

  @override
  State<_BouncingEmoji> createState() => _BouncingEmojiState();
}

class _BouncingEmojiState extends State<_BouncingEmoji> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
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
      builder: (_, __) => Transform.translate(
        offset: Offset(0, -8 * math.sin(_ctrl.value * math.pi)),
        child: Text(widget.emoji, style: TextStyle(fontSize: widget.size)),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// CANVAS PAINTER – Tinta ungu konsisten
// ═══════════════════════════════════════════════════════════════════════════════
class _ExamCanvasPainter extends CustomPainter {
  final List<Offset?> points;
  _ExamCanvasPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6C63FF)
      ..strokeWidth = 14.0
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

// ═══════════════════════════════════════════════════════════════════════════════
// NOTEBOOK LINES PAINTER – Garis buku tulis
// ═══════════════════════════════════════════════════════════════════════════════
class _NotebookLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFE2E8F0).withOpacity(0.6)
      ..strokeWidth = 2.0;
    const spacing = 48.0;
    for (double y = spacing; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}