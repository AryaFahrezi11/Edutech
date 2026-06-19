import 'package:flutter/material.dart';
import 'dart:ui';

class HandwritingCanvasPainter extends CustomPainter {
  final List<Offset?> userPoints; // Coretan jari anak

  HandwritingCanvasPainter({required this.userPoints});

  @override
  void paint(Canvas canvas, Size size) {
    // Pengaturan tinta spidol ungu pastel yang lucu untuk anak-anak
    final userPaint = Paint()
      ..color = const Color(0xFF6C63FF).withOpacity(0.8) // Sedikit transparan agar titik font di bawahnya tetap kelihatan
      ..strokeWidth = 26.0 // Ketebalan spidol yang pas dengan ukuran font
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    Path userPath = Path();
    bool isNewSubpath = true;
    
    for (int i = 0; i < userPoints.length; i++) {
      if (userPoints[i] == null) {
        isNewSubpath = true;
      } else {
        if (isNewSubpath) {
          userPath.moveTo(userPoints[i]!.dx, userPoints[i]!.dy);
          isNewSubpath = false;
        } else {
          userPath.lineTo(userPoints[i]!.dx, userPoints[i]!.dy);
        }
      }
    }
    canvas.drawPath(userPath, userPaint);
  }

  @override
  bool shouldRepaint(covariant HandwritingCanvasPainter oldDelegate) {
    return oldDelegate.userPoints != userPoints;
  }
}