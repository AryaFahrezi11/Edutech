import 'package:flutter/material.dart';
import 'dart:ui';

class HandwritingCanvasPainter extends CustomPainter {
  final List<Offset?> userPoints; // Goresan jari anak
  final String targetLetter; // Huruf hantu (A, B, C, dst.)
  final List<List<Offset>> targetPaths; // Koordinat panduan stroke (hantu)
  final int currentStroke; // Stroke yang harus dikerjakan

  HandwritingCanvasPainter({
    required this.userPoints,
    required this.targetLetter,
    required this.targetPaths,
    required this.currentStroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // --- 1. GAMBAR GARIS BANTU BUKU TULIS (BACKGROUND) ---
    final gridPaint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..strokeWidth = 1.0;
    
    // Garis horizontal (ruling lines)
    for (int i = 1; i < 6; i++) {
      double y = size.height * (i / 6);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // --- 2. GAMBAR GHOST LETTER (DASHED LINE & FUN NUMBERS) ---
    final ghostPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int s = 0; s < targetPaths.length; s++) {
      final pathCoords = targetPaths[s];
      if (pathCoords.length < 2) continue;

      // Gambar ghost path sebagai garis putus-putus
      final dashedPath = _createDashedPath(pathCoords);
      canvas.drawPath(dashedPath, ghostPaint);

      // Gambar Nomor Stroke & Panah di awal path (agar seru!)
      if (pathCoords.isNotEmpty) {
        final startPoint = pathCoords.first;
        // Gunakan Star/Fun Icon untuk nomor, bukan angka biasa kaku
        _drawStrokeGuideCharacter(canvas, startPoint, s + 1);
      }
    }

    // --- 3. GAMBAR GORESAN JARI ANAK (REAL-TIME PROGRESS) ---
    // Gunakan Paint-like style agar fun
    final userPaint = Paint()
      ..color = Colors.greenAccent[400]! // Vibrant Green
      ..strokeWidth = 12.0 // Lebih tebal agar terasa melukis
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < userPoints.length - 1; i++) {
      if (userPoints[i] != null && userPoints[i + 1] != null) {
        canvas.drawLine(userPoints[i]!, userPoints[i + 1]!, userPaint);
      }
    }
  }

  // Fungsi helper untuk karakter panduan stroke (lebih fun dari angka biasa)
  void _drawStrokeGuideCharacter(Canvas canvas, Offset position, int strokeNum) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '🌟 $strokeNum', // Contoh: Pintang panduan
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, position - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  // Fungsi helper membuat path putus-putus
  Path _createDashedPath(List<Offset> points) {
    Path path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    // Logic garis putus-putus sederhana
    Path dashedPath = Path();
    double dashWidth = 10.0;
    double dashSpace = 10.0;
    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashedPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    return dashedPath;
  }

  @override
  bool shouldRepaint(covariant HandwritingCanvasPainter oldDelegate) {
    return oldDelegate.userPoints != userPoints || 
           oldDelegate.targetLetter != targetLetter ||
           oldDelegate.currentStroke != currentStroke;
  }
}