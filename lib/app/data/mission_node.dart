import 'package:flutter/material.dart';

/// Tipe node misi pada peta perjalanan
enum MissionType {
  writingPractice,   // Latihan Menulis
  spellingPractice,  // Latihan Mengeja
  writingExam,       // Ujian Menulis (Boss)
  spellingExam,      // Ujian Mengeja (Boss)
  objectHuntPractice, // Latihan Berburu Benda
  objectHuntExam,     // Ujian Berburu Benda (Boss)
}

/// Data model untuk satu node misi di peta perjalanan
class MissionNode {
  final int index;
  final String title;
  final String subtitle;
  final String emoji;
  final MissionType type;
  final String routeName;
  final Map<String, dynamic>? arguments;
  final bool isBoss; // true = ujian/boss node (setiap 5 langkah)
  final List<Color> gradient;

  const MissionNode({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.type,
    required this.routeName,
    this.arguments,
    required this.isBoss,
    required this.gradient,
  });
}
