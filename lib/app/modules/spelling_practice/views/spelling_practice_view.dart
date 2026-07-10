import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/spelling_practice_controller.dart';
import '../../../services/progress_service.dart';

class SpellingPracticeView extends GetView<SpellingPracticeController> {
  const SpellingPracticeView({super.key});

  @override
  Widget build(BuildContext context) {
    final type = Get.arguments?['type'] ?? 'letter';

    // =========================================================
    // MODE KATA MUDAH
    // =========================================================

    if (type == 'word') {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),

        body: SafeArea(
          child: Obx(() {
            final word = controller.currentWord;

            // pecah ejaan
            final spellParts = word['spell'].toString().split('•');

            return Column(
              children: [
                _buildHeader(
                  title: "🧩 Latihan Eja Kata",
                  subtitle: "Belajar mengeja kata mudah",
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),

                    child: Container(
                      width: double.infinity,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.12),
                            blurRadius: 20,
                          ),
                        ],
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(24),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            const SizedBox(height: 35),

                            // =================================================
                            // KATA & IKON
                            // =================================================
                            if (word['icon'] != null)
                              Text(
                                word['icon'],
                                style: const TextStyle(fontSize: 100),
                              ),
                            
                            const SizedBox(height: 10),

                            Text(
                              word['word'],
                              style: const TextStyle(
                                fontSize: 68,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFE65100),
                              ),
                            ),

                            const SizedBox(height: 35),

                            // =================================================
                            // BOX EJAAN
                            // =================================================
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 14,
                              runSpacing: 14,

                              children: List.generate(spellParts.length, (
                                index,
                              ) {
                                final part = spellParts[index].trim();

                                return GestureDetector(
                                    onTap: () {
                                      controller.speakSpell(part);
                                    },

                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),

                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 28,
                                      vertical: 22,
                                    ),

                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFF9800),
                                          Color(0xFFFFC107),
                                        ],
                                      ),

                                      borderRadius: BorderRadius.circular(24),

                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange.withOpacity(
                                            0.25,
                                          ),

                                          blurRadius: 14,

                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),

                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.volume_up,
                                          color: Colors.white,
                                          size: 28,
                                        ),

                                        const SizedBox(height: 8),

                                        Text(
                                          part,
                                          style: const TextStyle(
                                            fontSize: 34,

                                            fontWeight: FontWeight.w900,

                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),

                            const SizedBox(height: 30),

                            // =================================================
                            // TOMBOL DENGAR EJAAN LENGKAP
                            // =================================================
                            Obx(() => SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton.icon(
                                onPressed: controller.isSpelling.value
                                    ? null
                                    : controller.speakFullSpelling,
                                icon: controller.isSpelling.value
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.record_voice_over_rounded,
                                        size: 28,
                                      ),
                                label: Text(
                                  controller.isSpelling.value
                                      ? "SEDANG MENGEJA..."
                                      : "🔊 DENGAR EJAAN",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 17,
                                    letterSpacing: 1,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: controller.isSpelling.value
                                      ? Colors.grey
                                      : const Color(0xFF4CAF50),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: controller.isSpelling.value ? 0 : 6,
                                  shadowColor: Colors.green.withOpacity(0.4),
                                ),
                              ),
                            )),

                            const SizedBox(height: 20),

                            // =================================================
                            // BACA KATA & LAFALKAN
                            // =================================================
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 58,
                                    child: ElevatedButton.icon(
                                      onPressed: controller.speakWord,
                                      icon: const Icon(Icons.volume_up_rounded, size: 28),
                                      label: const Text("DENGAR", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepOrange,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Obx(() => SizedBox(
                                    height: 58,
                                    child: ElevatedButton.icon(
                                      onPressed: controller.listen,
                                      icon: controller.isListening.value 
                                        ? const Icon(Icons.mic_rounded, size: 28)
                                        : const Icon(Icons.mic_none_rounded, size: 28),
                                      label: const Text("LAFALKAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: controller.isListening.value ? Colors.red : const Color(0xFF1CB0F6),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                        elevation: controller.isListening.value ? 10 : 2,
                                      ),
                                    ),
                                  )),
                                ),
                              ],
                            ),

                            const SizedBox(height: 38),

                            // =================================================
                            // NAVIGASI
                            // =================================================
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: controller.previousWord,

                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange.shade100,

                                      foregroundColor: Colors.deepOrange,
                                    ),

                                    child: const Text("⬅ Sebelumnya"),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                  Expanded(
                                    child: Obx(() {
                                      final progress = Get.find<ProgressService>().unlockedSpellingWord.value;
                                      final isLocked = controller.currentIndex.value >= progress;
                                      return ElevatedButton(
                                        onPressed: isLocked ? () {
                                          Get.snackbar(
                                            "Terkunci 🔒", 
                                            "Kamu harus lafalkan kata ini dengan benar dulu!",
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.orange,
                                            colorText: Colors.white,
                                            margin: const EdgeInsets.all(16),
                                            borderRadius: 20,
                                          );
                                        } : controller.nextWord,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isLocked ? Colors.grey : Colors.orange,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: Text(isLocked ? "🔒 Terkunci" : "Berikutnya ➡"),
                                      );
                                    }),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      );
    }

    // =========================================================
    // MODE HURUF
    // =========================================================

    final letters = controller.letters;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      body: SafeArea(
        child: Obx(() {
          final currentIndex = controller.currentIndex.value;

          final item = letters[currentIndex];

          return Column(
            children: [
              _buildHeader(
                title: "🔤 Latihan Huruf",
                subtitle: "Belajar huruf A - Z",
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  child: Container(
                    width: double.infinity,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.12),

                          blurRadius: 20,
                        ),
                      ],
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(24),

                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),

                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)],
                              ),

                              borderRadius: BorderRadius.circular(24),
                            ),

                            child: Column(
                              children: [
                                const Text(
                                  "🔤",
                                  style: TextStyle(fontSize: 55),
                                ),

                                const SizedBox(height: 12),

                                Text(
                                  "Huruf ${item['upper']}",

                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,

                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          // =================================================
                          // HURUF BESAR
                          // =================================================
                          Container(
                            height: 280,
                            width: double.infinity,

                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),

                              borderRadius: BorderRadius.circular(30),
                            ),

                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    item['upper']!,

                                    style: const TextStyle(
                                      fontSize: 170,

                                      fontWeight: FontWeight.w900,

                                      color: Color(0xFFE65100),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  right: 28,
                                  bottom: 24,

                                  child: Text(
                                    item['lower']!,

                                    style: TextStyle(
                                      fontSize: 60,

                                      fontWeight: FontWeight.bold,

                                      color: Colors.orange.shade400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 56,
                                  child: ElevatedButton.icon(
                                    onPressed: controller.playSound,
                                    icon: const Icon(Icons.volume_up_rounded, size: 26),
                                    label: const Text("DENGAR", style: TextStyle(fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Obx(() => SizedBox(
                                  height: 56,
                                  child: ElevatedButton.icon(
                                    onPressed: controller.listen,
                                    icon: controller.isListening.value 
                                        ? const Icon(Icons.mic_rounded, size: 26)
                                        : const Icon(Icons.mic_none_rounded, size: 26),
                                    label: const Text("LAFALKAN", style: TextStyle(fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: controller.isListening.value ? Colors.red : const Color(0xFF1CB0F6),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                      elevation: controller.isListening.value ? 10 : 2,
                                    ),
                                  ),
                                )),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // =================================================
                          // NAVIGASI
                          // =================================================
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: controller.previousItem,

                                  child: const Text("⬅ Sebelumnya"),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Obx(() {
                                  final progress = Get.find<ProgressService>().unlockedSpellingLetter.value;
                                  final isLocked = controller.currentIndex.value >= progress;
                                  return ElevatedButton(
                                    onPressed: isLocked ? () {
                                      Get.snackbar(
                                        "Terkunci 🔒", 
                                        "Kamu harus lafalkan huruf ini dengan benar dulu!",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.orange,
                                        colorText: Colors.white,
                                        margin: const EdgeInsets.all(16),
                                        borderRadius: 20,
                                      );
                                    } : controller.nextItem,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isLocked ? Colors.grey : const Color(0xFF1CB0F6),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text(isLocked ? "🔒 Terkunci" : "Berikutnya ➡"),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          );
        }),
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader({required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 14, 12, 16),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)],
        ),

        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),

      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),

            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  subtitle,

                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
