import 'dart:ui';
import 'dart:math' show pi, cos, sin;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_drawing/path_drawing.dart';
import '../controllers/writing_practice_controller.dart';

class WritingPracticeView extends GetView<WritingPracticeController> {
  const WritingPracticeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            Expanded(child: _buildCanvas()),
            const SizedBox(height: 24),
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
        gradient: LinearGradient(colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: Row(
        children: [
          // Tombol Kembali
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 4),
          // Judul Fitur
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "🖍️ Belajar Menulis", 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                SizedBox(height: 2),
                Text(
                  "Ikuti garisnya pelan-pelan ya!", 
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70),
                ),
              ],
            ),
          ),
          // Tombol Reset
          GestureDetector(
            onTap: controller.resetCanvas,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: const Text("🗑️", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  // ─── CANVAS AREA ──────────────────────────────────────────────────────────
  Widget _buildCanvas() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.06), 
              blurRadius: 20, 
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            children: [
              // 1. Garis Buku Tulis Esensial
              CustomPaint(
                painter: _StripesPainter(),
                child: const SizedBox.expand(),
              ),

              // 2. Pusat Konten: Font Asli & Sistem Tracing Presisi
              Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: FittedBox(
                    child: SizedBox(
                      width: 350,
                      height: 350,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          
                          // --- LAYER 1: HURUF DARI TRACING FONT ASLI ---
                          Obx(() => Text(
                            controller.selectedLetter.value,
                            style: const TextStyle(
                              fontFamily: 'KGPrimaryDots', 
                              fontSize: 320, 
                              color: Colors.black12, // Warna pudar
                              height: 1.0,
                            ),
                          )),

                          // --- LAYER 2: INTERAKSI GESTURE & DRAWING LURUS ---
                          GestureDetector(
                            onPanUpdate: controller.onPanUpdate,
                            onPanEnd: (_) => controller.onPanEnd(),
                            child: Obx(() {
                              final metrics = controller.currentMetrics;
                              if (metrics.isEmpty) return const SizedBox(width: 350, height: 350);

                              return Stack(
                                children: [
                                  // Tinta yang sudah di-fill (lurus presisi)
                                  CustomPaint(
                                    size: const Size(350, 350),
                                    painter: _StrictTracingPainter(
                                      completedPaths: controller.completedPaths.toList(),
                                      currentMetric: controller.currentStrokeIndex.value < metrics.length 
                                          ? metrics[controller.currentStrokeIndex.value] 
                                          : null,
                                      currentProgress: controller.currentStrokeProgress.value,
                                    ),
                                  ),
                                  
                                  // Ikon Pensil Penuntun
                                  if (controller.currentStrokeIndex.value < metrics.length)
                                    Builder(
                                      builder: (context) {
                                        final metric = metrics[controller.currentStrokeIndex.value];
                                        final tangent = metric.getTangentForOffset(
                                            metric.length * controller.currentStrokeProgress.value);
                                        if (tangent == null) return const SizedBox();
                                        
                                        final offset = tangent.position;
                                        return Positioned(
                                          left: offset.dx - 20,
                                          top: offset.dy - 20,
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF1CB0F6).withOpacity(0.5),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                              border: Border.all(color: const Color(0xFF1CB0F6), width: 2),
                                            ),
                                            child: const Center(
                                              child: Icon(Icons.edit_rounded, color: Color(0xFF1CB0F6), size: 24),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              );
                            }),
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Tombol navigasi kiri dan kanan dihapus agar anak tidak bisa skip huruf sembarangan
            ],
          ),
        ),
      ),
    );
  }


  Widget _navButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3))
          ],
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

// ─── BACKGROUND STRIPES PAINTER (Garis Buku Halus) ─────────────────────────
class _StripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 2.0;

    const spacing = 45.0;
    for (double y = spacing; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── STRICT TRACING PAINTER (Menggambar tinta lurus & Penunjuk Arah) ────────
class _StrictTracingPainter extends CustomPainter {
  final List<Path> completedPaths;
  final PathMetric? currentMetric;
  final double currentProgress;

  _StrictTracingPainter({
    required this.completedPaths,
    required this.currentMetric,
    required this.currentProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Gambar panduan arah untuk sisa stroke yang belum dikerjakan
    if (currentMetric != null) {
      final remainingPath = currentMetric!.extractPath(
        currentMetric!.length * currentProgress, 
        currentMetric!.length,
      );

      final guidePaint = Paint()
        ..color = const Color(0xFF1CB0F6).withOpacity(0.3) // Biru muda transparan
        ..strokeWidth = 10.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final dashedGuide = dashPath(
        remainingPath, 
        dashArray: CircularIntervalList<double>([10, 15]), // Putus-putus
      );
      
      canvas.drawPath(dashedGuide, guidePaint);

      // Gambar segitiga (kepala panah) di ujung stroke
      final endTangent = currentMetric!.getTangentForOffset(currentMetric!.length);
      if (endTangent != null && currentProgress < 0.9) {
        _drawArrowHead(canvas, endTangent.position, endTangent.vector, const Color(0xFF1CB0F6).withOpacity(0.5));
      }
    }

    final paint = Paint()
      ..color = const Color(0xFF6C63FF).withOpacity(0.8)
      ..strokeWidth = 26.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // 2. Gambar stroke yang sudah selesai sepenuhnya
    for (final p in completedPaths) {
      canvas.drawPath(p, paint);
    }

    // 3. Gambar stroke yang sedang dikerjakan (sesuai progress)
    if (currentMetric != null && currentProgress > 0) {
      final currentPath = currentMetric!.extractPath(0, currentMetric!.length * currentProgress);
      canvas.drawPath(currentPath, paint);
    }
  }

  void _drawArrowHead(Canvas canvas, Offset position, Offset direction, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final angle = direction.direction; 
    const arrowLength = 22.0;
    
    final p1 = position;
    final p2 = Offset(
      position.dx - arrowLength * cos(angle - pi / 6),
      position.dy - arrowLength * sin(angle - pi / 6),
    );
    final p3 = Offset(
      position.dx - arrowLength * cos(angle + pi / 6),
      position.dy - arrowLength * sin(angle + pi / 6),
    );

    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _StrictTracingPainter oldDelegate) {
    return oldDelegate.completedPaths.length != completedPaths.length ||
           oldDelegate.currentProgress != currentProgress ||
           oldDelegate.currentMetric != currentMetric;
  }
}