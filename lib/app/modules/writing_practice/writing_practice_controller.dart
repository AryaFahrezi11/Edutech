import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WritingPracticeController extends GetxController {
  // Huruf terpilih
  var selectedLetter = 'A'.obs;

  // Koordinat goresan jari anak
  var userPoints = <Offset?>[].obs;

  // Panduan stroke (hantu) untuk huruf 'A' (simulasi data PSC 2)
  // Stroke 1: Garis miring kiri (Atas ke Bawah-Kiri)
  // Stroke 2: Garis miring kanan (Atas ke Bawah-Kanan)
  // Stroke 3: Garis datar tengah (Kiri ke Kanan)
  final List<List<Offset>> letterA_Paths = [
    [const Offset(150, 100), const Offset(80, 250)], // Stroke 1
    [const Offset(150, 100), const Offset(220, 250)], // Stroke 2
    [const Offset(100, 200), const Offset(200, 200)], // Stroke 3
  ];

  // Index stroke hantu yang sedang harus dikerjakan
  var currentStroke = 0.obs;

  // Fungsi saat anak mengusap jari
  void onPanUpdate(DragUpdateDetails details) {
    // Tambahkan poin jari anak
    userPoints.add(details.localPosition);
    
    // Logika simulasi "Audit Goresan" (PSC 2 Core Logic)
    _auditUserProgress(details.localPosition);
  }

  // Fungsi saat anak mengangkat jari
  void onPanEnd() {
    // Tandai akhir goresan
    userPoints.add(null);
  }

  // Logika audit progress goresan (Simulasi Audit Trail)
  void _auditUserProgress(Offset currentTouchPoint) {
    if (currentStroke.value >= letterA_Paths.length) return;

    // Ambil koordinat panduan untuk stroke saat ini
    final currentPathGuide = letterA_Paths[currentStroke.value];
    if (currentPathGuide.length < 2) return;

    final targetEndPoint = currentPathGuide.last;
    
    // Hitung jarak jari anak ke target titik akhir stroke
    double distance = (currentTouchPoint - targetEndPoint).distance;

    // Jika jari anak cukup dekat dengan target (ambang batas), tandai stroke selesai
    if (distance < 20.0) {
      Get.snackbar(
        "Hebat!",
        "Goresan ${currentStroke.value + 1} selesai!",
        backgroundColor: Colors.greenAccent[100],
        snackPosition: SnackPosition.BOTTOM,
      );
      currentStroke.value++;
      userPoints.add(null); // Tandai akhir stroke untuk painter
    }
  }

  // Fungsi untuk reset kanvas
  void resetCanvas() {
    userPoints.clear();
    currentStroke.value = 0;
  }

  // Fungsi kirim data ke Backend (Mobile/Web Service Principle)
  void checkGoresanAudit() async {
    if (currentStroke.value < letterA_Paths.length) {
      Get.snackbar("Ayo!", "Selesaikan semua goresan dulu!");
      return;
    }

    // Ubah koordinat Offset menjadi List map agar bisa di-JSON-kan
    final coordsPayload = userPoints
        .where((p) => p != null)
        .map((p) => {'x': p!.dx, 'y': p!.dy})
        .toList();

    // Data siap dikirim ke backend Flask via HTTP POST
    // (Ini logic integrasi ke Backend Flask - Mobile/Web Service)
    Get.dialog(const Center(child: CircularProgressIndicator()));
    await Future.delayed(const Duration(seconds: 2)); // Simulasi audit
    Get.back();
    Get.snackbar("Audit Selesai!", "AI bilang goresanmu BAGUS!");
  }
}