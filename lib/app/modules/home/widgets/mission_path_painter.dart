import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

/// CustomPainter yang menggambar garis dashed zigzag
/// menghubungkan setiap node misi dari bawah ke atas.
class MissionPathPainter extends CustomPainter {
  final int nodeCount;
  final int currentNodeIndex;
  final double nodeSpacing;
  final double zigzagOffset;

  MissionPathPainter({
    required this.nodeCount,
    required this.currentNodeIndex,
    required this.nodeSpacing,
    required this.zigzagOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (nodeCount < 2) return;

    final centerX = size.width / 2;

    // Paint untuk garis yang sudah dilalui (completed)
    final completedPaint = Paint()
      ..color = const Color(0xFF1CB0F6)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Paint untuk garis yang belum dilalui (locked)
    final lockedPaint = Paint()
      ..color = const Color(0xFFE5E5E5)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < nodeCount - 1; i++) {
      // Posisi Y tiap node (dari bawah ke atas, reversed di layout)
      final startY = i * nodeSpacing + nodeSpacing / 2;
      final endY = (i + 1) * nodeSpacing + nodeSpacing / 2;

      // Zigzag X offset: alternates kiri-tengah-kanan
      final startX = centerX + _getZigzagX(i);
      final endX = centerX + _getZigzagX(i + 1);

      // Build smooth curve path
      final path = Path();
      path.moveTo(startX, startY);

      // Bezier curve untuk smooth path
      final controlY = (startY + endY) / 2;
      path.cubicTo(
        startX, controlY,
        endX, controlY,
        endX, endY,
      );

      // Pilih paint berdasarkan progress
      final isCompleted = i < currentNodeIndex;
      final paint = isCompleted ? completedPaint : lockedPaint;

      // Gambar dashed line
      canvas.drawPath(
        dashPath(path, dashArray: CircularIntervalList<double>(<double>[10, 6])),
        paint,
      );
    }
  }

  double _getZigzagX(int index) {
    // Pattern zigzag: kiri, tengah, kanan, tengah, kiri, ...
    final patterns = [
      -zigzagOffset,  // kiri
      0.0,            // tengah
      zigzagOffset,   // kanan
      0.0,            // tengah
    ];
    return patterns[index % patterns.length];
  }

  @override
  bool shouldRepaint(covariant MissionPathPainter oldDelegate) {
    return oldDelegate.currentNodeIndex != currentNodeIndex ||
        oldDelegate.nodeCount != nodeCount;
  }
}
