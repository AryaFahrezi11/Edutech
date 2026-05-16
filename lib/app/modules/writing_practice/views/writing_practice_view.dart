import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/writing_practice_controller.dart';
import 'handwriting_canvas_painter.dart';

class WritingPracticeView extends GetView<WritingPracticeController> {
  const WritingPracticeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 10),
            Expanded(child: _buildCanvas()),
            _buildBottomControls(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // ─── HEADER ───────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 20, 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 4),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("✏️ Latihan Menulis", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                SizedBox(height: 2),
                Text("Ikuti panduan dan tulis hurufnya!", style: TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ),
          // Stroke counter badge
          Obx(() => _buildStrokeBadge()),
        ],
      ),
    );
  }

  Widget _buildStrokeBadge() {
    final done = controller.currentStroke.value;
    final total = controller.currentPaths.length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
      ),
      child: Row(
        children: [
          const Text("🖊️ ", style: TextStyle(fontSize: 14)),
          Text(
            "$done/$total",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // ─── CANVAS AREA ──────────────────────────────────────────────────────────
  Widget _buildCanvas() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD), // Light blue background seperti referensi
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(color: const Color(0xFF6C63FF).withOpacity(0.12), blurRadius: 24, spreadRadius: 4, offset: const Offset(0, 8)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            children: [
              // 1. Background Garis Buku Tulis (Stripes)
              CustomPaint(
                painter: _StripesPainter(),
                child: const SizedBox.expand(),
              ),

              // 2. Canvas Menulis (Tengah, ukuran tetap responsif)
              Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: FittedBox(
                    child: SizedBox(
                      width: 350,
                      height: 350,
                      child: GestureDetector(
                        onPanUpdate: controller.onPanUpdate,
                        onPanEnd: (_) => controller.onPanEnd(),
                        child: Obx(() => CustomPaint(
                          size: const Size(350, 350),
                          painter: HandwritingCanvasPainter(
                            userPoints: controller.userPoints.toList(),
                            targetLetter: controller.selectedLetter.value,
                            targetPaths: controller.currentPaths,
                            currentStroke: controller.currentStroke.value,
                          ),
                        )),
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Tombol Navigasi Kiri (Mengambang)
              Positioned(
                left: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Obx(() {
                    final isFirst = controller.selectedLetter.value == 'A';
                    return _navButton(
                      icon: Icons.arrow_back_ios_rounded,
                      color: isFirst ? Colors.grey.shade400 : const Color(0xFFFF9F1C),
                      onTap: isFirst ? () {} : controller.prevLetter,
                    );
                  }),
                ),
              ),

              // 4. Tombol Navigasi Kanan (Mengambang)
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Obx(() {
                    final isLast = controller.selectedLetter.value == 'Z';
                    return _navButton(
                      icon: Icons.arrow_forward_ios_rounded,
                      color: isLast ? Colors.grey.shade400 : const Color(0xFFFF9F1C),
                      onTap: isLast ? () {} : controller.nextLetter,
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 72,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF6C63FF).withOpacity(0.08), const Color(0xFF48C6EF).withOpacity(0.08)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(left: BorderSide(color: const Color(0xFF6C63FF).withOpacity(0.12), width: 1.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _sidebarButton(
            emoji: "🔊",
            label: "Suara",
            color: const Color(0xFF6C63FF),
            onTap: () {},
          ),
          const SizedBox(height: 20),
          _sidebarButton(
            emoji: "🗑️",
            label: "Hapus",
            color: const Color(0xFFFF6B6B),
            onTap: controller.resetCanvas,
          ),
          const SizedBox(height: 20),
          _sidebarButton(
            emoji: "💡",
            label: "Petunjuk",
            color: const Color(0xFFFFD700),
            onTap: () => Get.snackbar(
              "Petunjuk ✏️",
              "Ikuti garis abu-abu sebagai panduanmu!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFF6C63FF).withOpacity(0.9),
              colorText: Colors.white,
              borderRadius: 20,
              margin: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarButton({required String emoji, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }

  // ─── BOTTOM CONTROLS ──────────────────────────────────────────────────────
  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main Check button
          Expanded(child: _buildCheckButton()),
        ],
      ),
    );
  }

  Widget _navButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  Widget _buildCheckButton() {
    return Obx(() {
      final done = controller.currentStroke.value >= controller.currentPaths.length;
      return GestureDetector(
        onTap: controller.checkGoresanAudit,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: done
                  ? [const Color(0xFF11998E), const Color(0xFF38EF7D)]
                  : [const Color(0xFF6C63FF), const Color(0xFF48C6EF)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (done ? const Color(0xFF11998E) : const Color(0xFF6C63FF)).withOpacity(0.4),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(done ? "✅" : "🖊️", style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                done ? "Selesai! Kirim Goresan" : "Cek Goresan",
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ─── BACKGROUND STRIPES PAINTER ──────────────────────────────────────────────
class _StripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 3.0;

    const spacing = 45.0;
    for (double y = spacing; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
