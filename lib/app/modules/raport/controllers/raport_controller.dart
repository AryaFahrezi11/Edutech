import 'package:get/get.dart';

class RaportController extends GetxController {
  // Data utama untuk Radar Chart (Big Data Kemampuan)
  // Urutan: Menulis, Mengeja, Membaca, Berhitung, Mendengar
  final skillData = <double>[85, 70, 92, 65, 88].obs;

  // Data mingguan untuk Bar Chart (Progres Belajar)
  final weeklyXP = <double>[200, 450, 300, 600, 500, 800, 400].obs;

  // Nama-nama kategori
  final categories = ['Tulis', 'Eja', 'Baca', 'Hitung', 'Dengar'];

  // Pesan motivasi berdasarkan data (Simulasi AI Analisis)
  String get analysisMessage {
    if (skillData[2] > 90) {
      return "Wah, kemampuan Membaca kamu luar biasa! Kamu sudah seperti profesor cilik! 🎓";
    }
    return "Terus semangat belajar ya, setiap hari kamu makin hebat! 🚀";
  }
}
