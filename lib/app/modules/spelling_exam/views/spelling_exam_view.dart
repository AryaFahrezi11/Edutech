import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/spelling_exam_controller.dart';

class SpellingExamView extends GetView<SpellingExamController> {
  const SpellingExamView({super.key});

  static const _primaryBlue = Color(0xFF1CB0F6);
  static const _darkBlue = Color(0xFF1899D6);
  static const _successGreen = Color(0xFF58CC02);
  static const _errorRed = Color(0xFFFF4B4B);
  static const _gold = Color(0xFFFFD900);
  static const _textDark = Color(0xFF3A2F6B);
  static const _textMuted = Color(0xFF8B88A0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // Background gamified yang lebih lembut
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Obx(() {
                switch (controller.examState.value) {
                  case ExamState.idle:
                  case ExamState.listening:
                    return _buildMainScreen();
                  case ExamState.checking:
                    return _buildCheckingScreen();
                  case ExamState.evaluating:
                    return _buildEvaluatingScreen();
                  case ExamState.result:
                    return _buildResultScreen(context);
                  case ExamState.countdown:
                    return const SizedBox();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({bool showScore = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _textDark, size: 28),
                onPressed: () => Get.back(),
              ),
              const SizedBox(width: 8),
              Text(
                controller.examTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: _textDark,
                ),
              ),
            ],
          ),
          if (showScore)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, color: _gold, size: 24),
                  const SizedBox(width: 6),
                  Obx(() => Text(
                    '${controller.score.value}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark),
                  )),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainScreen() {
    final q = controller.currentQuestion;
    return Column(
      children: [
        _buildHeader(showScore: true),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                // Kartu Pertanyaan (3D Game Style)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: _primaryBlue.withOpacity(0.1), width: 3),
                      boxShadow: [
                        BoxShadow(color: _primaryBlue.withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 10)),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Gambar/Ikon/Maskot di dalam kartu
                        if (q['icon'] != null)
                          Text(
                            q['icon'],
                            style: const TextStyle(fontSize: 100),
                          )
                        else
                          Lottie.asset(
                            controller.category == 'word' ? 'assets/lotties/owl.json' : 'assets/lotties/cute-cat.json',
                            height: 120,
                          ),
                        const SizedBox(height: 20),
                        
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FBFF),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: _primaryBlue.withOpacity(0.3), width: 2),
                          ),
                          child: Text(
                            q['answer'],
                            style: const TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.w900,
                              color: _primaryBlue,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        Obx(() {
                          final isEmpty = controller.spokenText.value.isEmpty;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            decoration: BoxDecoration(
                              color: isEmpty ? Colors.transparent : _primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isEmpty 
                                  ? (controller.isListening.value ? "Mendengarkan..." : "Tekan Lafalkan lalu ucapkan") 
                                  : controller.spokenText.value,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: isEmpty ? _textMuted : _primaryBlue,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Tombol Microphone (Gamified 3D)
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: Obx(() {
                    final isListening = controller.isListening.value;
                    return GestureDetector(
                      onTap: () {
                        if (isListening) {
                          controller.stopListening();
                        } else {
                          controller.startListening();
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isListening ? [_errorRed, const Color(0xFFD32F2F)] : [_primaryBlue, _darkBlue],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: (isListening ? _errorRed : _primaryBlue).withOpacity(0.4),
                              blurRadius: isListening ? 20 : 8,
                              spreadRadius: isListening ? 4 : 0,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: isListening ? const Color(0xFFB71C1C) : const Color(0xFF1480B0),
                              blurRadius: 0,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isListening ? Icons.mic_rounded : Icons.mic_none_rounded, 
                              color: Colors.white, 
                              size: 32
                            ),
                            const SizedBox(width: 12),
                            Text(
                              isListening ? "BERHENTI" : "LAFALKAN", 
                              style: const TextStyle(
                                fontWeight: FontWeight.w900, 
                                fontSize: 22, 
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lotties/fish.json', height: 150),
          const SizedBox(height: 24),
          const Text(
            "Mengecek Suaramu...", 
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: _primaryBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluatingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            controller.category == 'word' ? 'assets/lotties/owl.json' : 'assets/lotties/cute-cat.json',
            height: 180,
          ),
          const SizedBox(height: 24),
          const Text(
            "Menganalisa Ejaan...", 
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: _primaryBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen(BuildContext context) {
    final isOk = controller.isCorrect.value;
    
    return Column(
      children: [
        _buildHeader(showScore: true),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  // Emoji reaksi dengan animasi / Maskot Evaluasi
                  ScaleTransition(
                    scale: controller.starsAnim,
                    child: isOk 
                        ? const Text('🌟', style: TextStyle(fontSize: 90))
                        : Lottie.asset(
                            controller.category == 'word' ? 'assets/lotties/owl.json' : 'assets/lotties/cute-cat.json',
                            height: 150,
                          ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    isOk ? 'Benar! Hebat! 🎉' : 'Hampir Benar! Yuk Coba Lagi',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: isOk ? _successGreen : _errorRed,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isOk
                        ? 'Kamu mengeja "${controller.currentQuestion['answer']}" dengan tepat!'
                        : 'Latihan lagi ya, kamu pasti bisa!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: _textMuted, height: 1.4),
                  ),
                  const SizedBox(height: 32),

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
                        const Text('⭐ Skor: ', style: TextStyle(fontSize: 18, color: _textMuted, fontWeight: FontWeight.w600)),
                        Obx(() => Text('${controller.score.value}',
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: _textDark))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Tombol Aksi (Lanjut / Kembali / Coba Lagi)
                  if (isOk)
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: controller.backToMenu,
                            child: Container(
                              height: 65,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: _primaryBlue.withOpacity(0.2), width: 2),
                              ),
                              child: const Center(
                                child: Text('Kembali', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _primaryBlue)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: controller.goToNextLevel,
                            child: Container(
                              height: 65,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [_primaryBlue, _darkBlue]),
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(color: _primaryBlue.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3)),
                                  const BoxShadow(color: Color(0xFF1480B0), blurRadius: 0, offset: Offset(0, 4)),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Lanjut', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                                  SizedBox(width: 8),
                                  Text('🚀', style: TextStyle(fontSize: 20)),
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
                              height: 65,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: _errorRed.withOpacity(0.2), width: 2),
                              ),
                              child: const Center(
                                child: Text('Kembali', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _errorRed)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: controller.retryLevel,
                            child: Container(
                              height: 65,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [_gold, Color(0xFFF39C12)]),
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(color: _gold.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3)),
                                  const BoxShadow(color: Color(0xFFD68910), blurRadius: 0, offset: Offset(0, 4)),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Coba Lagi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                                  SizedBox(width: 8),
                                  Text('🔄', style: TextStyle(fontSize: 20)),
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
        ),
      ],
    );
  }
}
