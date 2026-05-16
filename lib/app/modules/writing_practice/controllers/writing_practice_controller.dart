import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WritingPracticeController extends GetxController {
  // Huruf terpilih
  var selectedLetter = 'A'.obs;

  @override
  void onInit() {
    super.onInit();
    // Tangkap argumen huruf dari halaman pemilihan jika ada
    if (Get.arguments != null && Get.arguments['letter'] != null) {
      selectedLetter.value = Get.arguments['letter'];
    }
  }

  void nextLetter() {
    int currentCode = selectedLetter.value.codeUnitAt(0);
    if (currentCode < 90) { // 90 adalah 'Z'
      selectedLetter.value = String.fromCharCode(currentCode + 1);
      resetCanvas();
    }
  }

  void prevLetter() {
    int currentCode = selectedLetter.value.codeUnitAt(0);
    if (currentCode > 65) { // 65 adalah 'A'
      selectedLetter.value = String.fromCharCode(currentCode - 1);
      resetCanvas();
    }
  }

  // Koordinat goresan jari anak
  var userPoints = <Offset?>[].obs;

  // Data pola (path) untuk berbagai huruf
  final Map<String, List<List<Offset>>> letterPathsMap = {
    'A': [
      [const Offset(150, 100), const Offset(80, 250)], // Stroke 1
      [const Offset(150, 100), const Offset(220, 250)], // Stroke 2
      [const Offset(100, 200), const Offset(200, 200)], // Stroke 3
    ],
    'B': [
      [const Offset(100, 100), const Offset(100, 250)], // Garis lurus kiri
      [const Offset(100, 100), const Offset(180, 120), const Offset(200, 150), const Offset(180, 175), const Offset(100, 175)], // Lengkung atas
      [const Offset(100, 175), const Offset(190, 200), const Offset(210, 225), const Offset(190, 250), const Offset(100, 250)], // Lengkung bawah
    ],
    'C': [
      [const Offset(220, 120), const Offset(150, 80), const Offset(80, 175), const Offset(150, 270), const Offset(220, 230)], // Lengkung C
    ],
    'D': [
      [const Offset(100, 100), const Offset(100, 250)], // Garis lurus kiri
      [const Offset(100, 100), const Offset(200, 120), const Offset(220, 175), const Offset(200, 230), const Offset(100, 250)], // Lengkung D
    ],
    'E': [
      [const Offset(100, 100), const Offset(100, 250)], // Garis lurus kiri
      [const Offset(100, 100), const Offset(200, 100)], // Atas
      [const Offset(100, 175), const Offset(180, 175)], // Tengah
      [const Offset(100, 250), const Offset(200, 250)], // Bawah
    ],
    'F': [
      [const Offset(100, 100), const Offset(100, 250)], // Garis lurus kiri
      [const Offset(100, 100), const Offset(200, 100)], // Atas
      [const Offset(100, 175), const Offset(180, 175)], // Tengah
    ],
    'G': [
      [const Offset(220, 120), const Offset(150, 80), const Offset(80, 175), const Offset(150, 270), const Offset(220, 250), const Offset(220, 180), const Offset(170, 180)], // Pola G
    ],
  };

  // Mendapatkan path sesuai huruf yang aktif
  List<List<Offset>> get currentPaths {
    return letterPathsMap[selectedLetter.value] ?? [
      // Fallback jika huruf belum ada polanya (Garis lurus vertikal sederhana)
      [const Offset(150, 100), const Offset(150, 250)], 
    ];
  }

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
    if (currentStroke.value >= currentPaths.length) return;

    // Ambil koordinat panduan untuk stroke saat ini
    final currentPathGuide = currentPaths[currentStroke.value];
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
    if (currentStroke.value < currentPaths.length) {
      Get.snackbar("Ayo!", "Selesaikan semua goresan dulu!");
      return;
    }

    // Ubah koordinat Offset menjadi List map agar bisa di-JSON-kan
    final coordsPayload = userPoints
        .where((p) => p != null)
        .map((p) => {'x': p!.dx, 'y': p!.dy}) // Gunakan ! jika diperlukan oleh compiler, namun jika IDE protes, hapus saja.
        .toList();

    // Data siap dikirim ke backend Flask via HTTP POST
    debugPrint("Mengirim data koordinat: $coordsPayload");

    Get.dialog(const Center(child: CircularProgressIndicator()));
    await Future.delayed(const Duration(seconds: 2)); // Simulasi audit
    Get.back();
    Get.snackbar("Audit Selesai!", "AI bilang goresanmu BAGUS!");
  }
}