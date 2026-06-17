import 'dart:ui';
import 'dart:math' show pi, cos, sin;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_drawing/path_drawing.dart';
import '../controllers/word_practice_controller.dart';

class WordPracticeView extends GetView<WordPracticeController> {
  const WordPracticeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Force call controller to initialize SystemChrome orientation
    controller;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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
                        // Garis buku
                        CustomPaint(
                          painter: _StripesPainter(),
                          child: const SizedBox.expand(),
                        ),
                        
                        // Jejeran Huruf
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Obx(() {
                              if (controller.lettersData.isEmpty) return const SizedBox();
                              
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(controller.lettersData.length, (index) {
                                  return Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: AspectRatio(
                                        aspectRatio: 1.0,
                                        child: FittedBox(
                                          child: SizedBox(
                                            width: 350,
                                            height: 350,
                                            child: _buildLetterCanvas(index),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 20, 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                  "🖍️ Menulis Kata: ${controller.word}", 
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                )),
                const SizedBox(height: 2),
                const Text(
                  "Tebalkan huruf secara berurutan!", 
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70),
                ),
              ],
            ),
          ),
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

  Widget _buildLetterCanvas(int index) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. Font Latar (bayangan abu-abu)
        Obx(() {
          final data = controller.lettersData[index];
          final isActive = index == controller.currentLetterIndex.value;
          final isDone = index < controller.currentLetterIndex.value;
          
          return Text(
            data.letter,
            style: TextStyle(
              fontFamily: 'KGPrimaryDots', 
              fontSize: 320, 
              // Huruf yang belum saatnya dikerjakan dibuat lebih transparan
              color: isActive || isDone ? Colors.black12 : Colors.black.withOpacity(0.04), 
              height: 1.0,
            ),
          );
        }),

        // 2. Gesture & Tinta
        GestureDetector(
          onPanUpdate: (details) => controller.onPanUpdate(details, index),
          onPanEnd: (_) => controller.onPanEnd(index),
          child: Obx(() {
            final data = controller.lettersData[index];
            final isActive = index == controller.currentLetterIndex.value;

            return Stack(
              children: [
                CustomPaint(
                  size: const Size(350, 350),
                  painter: _StrictTracingPainter(
                    completedPaths: data.completedPaths,
                    currentMetric: data.currentStrokeIndex < data.metrics.length 
                        ? data.metrics[data.currentStrokeIndex] 
                        : null,
                    currentProgress: data.currentStrokeProgress,
                    isActive: isActive,
                  ),
                ),
                
                // Ikon Pensil
                if (isActive && data.currentStrokeIndex < data.metrics.length)
                  Builder(
                    builder: (context) {
                      final metric = data.metrics[data.currentStrokeIndex];
                      final tangent = metric.getTangentForOffset(
                          metric.length * data.currentStrokeProgress);
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
    );
  }
}

// ─── BACKGROUND STRIPES PAINTER ─────────────────────────
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

// ─── STRICT TRACING PAINTER ────────
class _StrictTracingPainter extends CustomPainter {
  final List<Path> completedPaths;
  final PathMetric? currentMetric;
  final double currentProgress;
  final bool isActive;

  _StrictTracingPainter({
    required this.completedPaths,
    required this.currentMetric,
    required this.currentProgress,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Gambar panduan arah untuk sisa stroke
    if (isActive && currentMetric != null) {
      final remainingPath = currentMetric!.extractPath(
        currentMetric!.length * currentProgress, 
        currentMetric!.length,
      );

      final guidePaint = Paint()
        ..color = const Color(0xFF1CB0F6).withOpacity(0.3)
        ..strokeWidth = 10.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final dashedGuide = dashPath(
        remainingPath, 
        dashArray: CircularIntervalList<double>([10, 15]), 
      );
      
      canvas.drawPath(dashedGuide, guidePaint);

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

    // 3. Gambar stroke yang sedang dikerjakan
    if (isActive && currentMetric != null && currentProgress > 0) {
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
    return true; // Simple approach to ensure it repaints when properties change
  }
}
