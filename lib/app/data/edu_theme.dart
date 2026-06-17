import 'package:flutter/material.dart';

/// ─── DUOLINGO-STYLE THEME CONSTANTS ─────────────────────────────────────────
/// Warna dan style yang konsisten di seluruh aplikasi Edutech,
/// terinspirasi dari desain gamifikasi Duolingo.
class EduTheme {
  EduTheme._();

  // ── PRIMARY COLORS ──
  static const Color primary = Color(0xFF1CB0F6);       // Blue gamifikasi utama
  static const Color primaryDark = Color(0xFF1899D6);    // Darker blue
  static const Color primaryLight = Color(0xFFB8E8FF);   // Light blue bg
  static const Color primaryShadow = Color(0xFF1282B8);  // Shadow blue

  // ── ACCENT COLORS ──
  static const Color blue = Color(0xFF1CB0F6);         // Info / secondary
  static const Color blueDark = Color(0xFF1899D6);
  static const Color red = Color(0xFFFF4B4B);          // Error / hearts
  static const Color redDark = Color(0xFFEA2B2B);
  static const Color orange = Color(0xFFFF9600);       // Warning / XP
  static const Color orangeDark = Color(0xFFE58600);
  static const Color purple = Color(0xFFCE82FF);       // Premium / special
  static const Color gold = Color(0xFFFFC800);         // Stars / achievement
  static const Color goldDark = Color(0xFFE5B400);

  // ── NEUTRAL COLORS ──
  static const Color bgLight = Color(0xFFF7F7F7);     // Background utama
  static const Color bgPrimaryTint = Color(0xFFF0F9FF); // Background primary tint
  static const Color cardWhite = Colors.white;
  static const Color textDark = Color(0xFF3C3C3C);
  static const Color textMedium = Color(0xFF777777);
  static const Color textLight = Color(0xFFAFAFAF);
  static const Color border = Color(0xFFE5E5E5);
  static const Color disabled = Color(0xFFD4D4D8);

  // ── GRADIENTS ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [blue, blueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [gold, orange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient redGradient = LinearGradient(
    colors: [red, redDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── BORDER RADIUS ──
  static const double radiusSm = 12;
  static const double radiusMd = 20;
  static const double radiusLg = 28;
  static const double radiusXl = 36;

  // ── SHADOWS ──
  static List<BoxShadow> softShadow({Color? color}) => [
    BoxShadow(
      color: (color ?? Colors.black).withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> buttonShadow(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.35),
      blurRadius: 12,
      offset: const Offset(0, 5),
    ),
  ];

  // ── COMMON DECORATIONS ──
  static BoxDecoration headerDecoration({required LinearGradient gradient}) =>
      BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(radiusXl),
        ),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      );

  static BoxDecoration cardDecoration({Color? borderColor}) => BoxDecoration(
    color: cardWhite,
    borderRadius: BorderRadius.circular(radiusLg),
    border: Border.all(
      color: borderColor ?? border,
      width: 2,
    ),
    boxShadow: softShadow(),
  );
}
