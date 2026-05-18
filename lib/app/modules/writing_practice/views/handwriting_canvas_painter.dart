import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

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
    // --- 1. GAMBAR FAT WHITE LETTER (BASIS BACKGROUND) ---
    // Background putih tebal agar terlihat seperti huruf balon (bubble font)
    final fatWhitePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 90.0 // Sangat tebal
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (int s = 0; s < targetPaths.length; s++) {
      final pathCoords = targetPaths[s];
      if (pathCoords.length < 2) continue;
      Path baseCurve = _createSmoothPath(pathCoords);
      canvas.drawPath(baseCurve, fatWhitePaint);
    }

    // --- 2. GAMBAR PANDUAN (ARROWS & MARKERS) ---
    for (int s = 0; s < targetPaths.length; s++) {
      final pathCoords = targetPaths[s];
      if (pathCoords.length < 2) continue;
      Path baseCurve = _createSmoothPath(pathCoords);

      if (s < currentStroke) {
        // Goresan yang sudah selesai (Bisa digambar warna berbeda/dikosongkan)
        // Kita biarkan tertutup oleh goresan jari anak
      } else if (s == currentStroke) {
        // Goresan saat ini: Gambar panah-panah oranye sepanjang jalan
        _drawArrowsAlongPath(canvas, baseCurve);
        
        // Gambar lingkaran biru penanda mulai di ujung awal (seperti di referensi)
        _drawStartMarker(canvas, pathCoords.first, targetLetter);
      } else {
        // Goresan masa depan: Gambar panah abu-abu tipis agar tidak membingungkan
        final futurePaint = Paint()
          ..color = Colors.grey.withOpacity(0.2)
          ..strokeWidth = 10.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;
        canvas.drawPath(baseCurve, futurePaint);
      }
    }

    // --- 3. GAMBAR GORESAN JARI ANAK (REAL-TIME PROGRESS) ---
    final userPaint = Paint()
      ..color = const Color(0xFF6C63FF) // Ungu terang
      ..strokeWidth = 35.0 // Tebal seperti spidol
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

  // Fungsi menggambar penanda mulai (Lingkaran biru dengan huruf di tengah)
  void _drawStartMarker(Canvas canvas, Offset position, String letter) {
    final circlePaint = Paint()..color = const Color(0xFF2855F4); // Biru seperti di gambar
    canvas.drawCircle(position, 20.0, circlePaint);
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, position - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  // Fungsi menggambar panah-panah kecil sepanjang kurva
  void _drawArrowsAlongPath(Canvas canvas, Path path) {
    final paint = Paint()
      ..color = const Color(0xFFFF9F1C) // Oranye seperti referensi
      ..style = PaintingStyle.fill;

    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 30.0; // Panah pertama mulai sedikit menjauh dari lingkaran awal
      while (distance < pathMetric.length) {
        Tangent? tangent = pathMetric.getTangentForOffset(distance);
        if (tangent != null) {
          canvas.save();
          canvas.translate(tangent.position.dx, tangent.position.dy);
          double angle = atan2(tangent.vector.dy, tangent.vector.dx);
          canvas.rotate(angle);
          
          // Gambar bentuk panah (menunjuk ke Kanan secara lokal karena sudah di-rotate)
          Path arrowPath = Path();
          arrowPath.moveTo(10, 0); // Ujung depan
          arrowPath.lineTo(-8, -10); // Belakang atas
          arrowPath.lineTo(-4, 0); // Lekukan belakang tengah
          arrowPath.lineTo(-8, 10); // Belakang bawah
          arrowPath.close();
          
          canvas.drawPath(arrowPath, paint);
          canvas.restore();
        }
        distance += 35.0; // Jarak antar panah
      }
    }
  }

  // Fungsi helper membuat path halus menggunakan kurva Bezier
  Path _createSmoothPath(List<Offset> points) {
    Path path = Path();
    if (points.isEmpty) return path;

    path.moveTo(points.first.dx, points.first.dy);
    
    if (points.length == 2) {
      path.lineTo(points.last.dx, points.last.dy);
    } else {
      for (int i = 1; i < points.length - 1; i++) {
        final p1 = points[i];
        final p2 = points[i + 1];
        final midX = (p1.dx + p2.dx) / 2;
        final midY = (p1.dy + p2.dy) / 2;
        
        path.quadraticBezierTo(p1.dx, p1.dy, midX, midY);
      }
      path.lineTo(points.last.dx, points.last.dy);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant HandwritingCanvasPainter oldDelegate) {
    return oldDelegate.userPoints != userPoints || 
           oldDelegate.targetLetter != targetLetter ||
           oldDelegate.currentStroke != currentStroke;
  }
}