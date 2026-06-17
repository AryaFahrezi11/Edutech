import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/spelling_exam_controller.dart';

class SpellingExamView extends GetView<SpellingExamController> {
  const SpellingExamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      body: SafeArea(
        child: Obx(() {
          switch (controller.examState.value) {
            case ExamState.idle:
              return _buildIdleScreen();

            case ExamState.countdown:
              return _buildCountdownScreen();

            case ExamState.listening:
              return _buildListeningScreen();

            case ExamState.checking:
              return _buildCheckingScreen();

            case ExamState.result:
              return _buildResultScreen();
          }
        }),
      ),
    );
  }

  // ───────────────── IDLE SCREEN ─────────────────
  Widget _buildIdleScreen() {
    return Column(
      children: [
        _buildHeader(showProgress: false),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Column(
              children: [
                const SizedBox(height: 20),

                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.elasticOut,

                  builder: (_, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },

                  child: Container(
                    width: 160,
                    height: 160,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withOpacity(0.25),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),

                    child: const Center(
                      child: Text("🎤", style: TextStyle(fontSize: 80)),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  controller.examTitle,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF3A2F6B),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Lihat kata lalu ucapkan dengan benar 😊",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF7B7B9A),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 32),

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
                      ),
                    ],
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _infoChip("📝", "${controller.questions.length}", "Soal"),

                      _divider(),

                      _infoChip("⭐", "100", "Nilai"),

                      _divider(),

                      _infoChip("🎤", "Voice", "Mode"),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                GestureDetector(
                  onTap: controller.startExam,

                  child: Container(
                    width: double.infinity,
                    height: 64,

                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)],
                      ),

                      borderRadius: BorderRadius.circular(24),

                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withOpacity(0.45),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("🚀", style: TextStyle(fontSize: 26)),

                        SizedBox(width: 12),

                        Text(
                          "Mulai Ujian!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
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

  // ───────────────── COUNTDOWN ─────────────────
  Widget _buildCountdownScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Text(
            "Bersiap!",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3A2F6B),
            ),
          ),

          const SizedBox(height: 30),

          Obx(
            () => Container(
              width: 140,
              height: 140,

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)],
                ),

                shape: BoxShape.circle,
              ),

              child: Center(
                child: Text(
                  "${controller.countdown.value}",
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── LISTENING SCREEN ─────────────────
  Widget _buildListeningScreen() {
    final q = controller.currentQuestion;

    return Column(
      children: [
        _buildHeader(showProgress: true),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Container(
              width: double.infinity,

              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const Text(
                    "📖 Bacakan Kata Berikut",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3A2F6B),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // KATA
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30),

                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)],
                      ),

                      borderRadius: BorderRadius.circular(24),
                    ),

                    child: Center(
                      child: Text(
                        q['answer'],
                        style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Tekan tombol mikrofon lalu ucapkan kata di atas",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Color(0xFF7B7B9A)),
                  ),

                  const SizedBox(height: 30),

                  // TOMBOL MIC
                  GestureDetector(
                    onTap: () async {
                      if (controller.isListening.value) {
                        await controller.stopListening();
                      } else {
                        await controller.startListening();
                      }
                    },

                    child: Obx(
                      () => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),

                        width: 130,
                        height: 130,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          gradient: LinearGradient(
                            colors: controller.isListening.value
                                ? [
                                    const Color(0xFFFF416C),
                                    const Color(0xFFFF4B2B),
                                  ]
                                : [
                                      const Color(0xFF1CB0F6),
                                      const Color(0xFF1899D6),
                                  ],
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: controller.isListening.value
                                  ? Colors.red.withOpacity(0.4)
                                  : const Color(0xFF6C63FF).withOpacity(0.35),

                              blurRadius: 20,
                              spreadRadius: 3,
                            ),
                          ],
                        ),

                        child: Icon(
                          controller.isListening.value
                              ? Icons.mic
                              : Icons.mic_none_rounded,

                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Obx(
                    () => Text(
                      controller.isListening.value
                          ? "🎙️ Sedang mendengarkan..."
                          : "🎤 Tekan untuk mulai bicara",

                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: controller.isListening.value
                            ? Colors.red
                            : const Color(0xFF6C63FF),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // HASIL SUARA USER
                  Obx(
                    () => Text(
                      controller.spokenText.value.isEmpty
                          ? "Belum ada suara"
                          : controller.spokenText.value,

                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3A2F6B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ───────────────── CHECKING ─────────────────
  Widget _buildCheckingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const _SpinningLoader(),

          const SizedBox(height: 24),

          const Text(
            "Memeriksa Jawaban...",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3A2F6B),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── RESULT ─────────────────
  Widget _buildResultScreen() {
    final isCorrect = controller.isCorrect.value;

    return Column(
      children: [
        _buildHeader(showProgress: true),

        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text(
                    isCorrect ? "🎉" : "😢",
                    style: const TextStyle(fontSize: 100),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    isCorrect ? "Jawaban Benar!" : "Jawaban Salah",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: isCorrect
                          ? const Color(0xFF11998E)
                          : const Color(0xFFFF6B6B),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Obx(
                    () => Text(
                      "Jawaban kamu:\n${controller.spokenText.value}",
                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF7B7B9A),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  GestureDetector(
                    onTap: controller.nextQuestion,

                    child: Container(
                      width: double.infinity,
                      height: 60,

                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)],
                        ),

                        borderRadius: BorderRadius.circular(22),
                      ),

                      child: Center(
                        child: Text(
                          controller.isLastQuestion
                              ? "🏁 Selesai"
                              : "➡️ Soal Berikutnya",

                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ───────────────── HEADER ─────────────────
  Widget _buildHeader({required bool showProgress}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 20, 16),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)],
        ),

        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),

      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),

                onPressed: () => Get.back(),
              ),

              Expanded(
                child: Text(
                  "🔤 ${controller.examTitle}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),

              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Text(
                    "⭐ ${controller.score.value}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),

          if (showProgress) ...[
            const SizedBox(height: 10),

            Obx(() {
              final progress =
                  (controller.currentQuestionIndex.value + 1) /
                  controller.questions.length;

              return ClipRRect(
                borderRadius: BorderRadius.circular(10),

                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,

                  backgroundColor: Colors.white.withOpacity(0.3),

                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
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

        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xFF3A2F6B),
          ),
        ),

        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF9090A0)),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 50, color: const Color(0xFFEEEEF5));
  }
}

// ───────────────── LOADER ─────────────────
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

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
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

      builder: (_, __) {
        return Transform.rotate(
          angle: _ctrl.value * 2 * math.pi,

          child: Container(
            width: 100,
            height: 100,

            decoration: const BoxDecoration(
              gradient: SweepGradient(
                colors: [
                  Color(0xFF1CB0F6),
                  Color(0xFF1899D6),
                  Colors.transparent,
                ],
              ),

              shape: BoxShape.circle,
            ),

            child: const Center(
              child: CircleAvatar(
                radius: 38,
                backgroundColor: Color(0xFFF0F4FF),

                child: Text("🤖", style: TextStyle(fontSize: 36)),
              ),
            ),
          ),
        );
      },
    );
  }
}
