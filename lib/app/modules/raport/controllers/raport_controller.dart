import 'package:get/get.dart';
import '../../../services/mongodb_service.dart';

class RaportController extends GetxController {
  // Data utama untuk Radar Chart (Big Data Kemampuan)
  final skillData = <double>[50, 50, 50, 50].obs;

  // Data mingguan untuk Bar Chart (Progres Belajar)
  final weeklyXP = <double>[200, 450, 300, 600, 500, 800, 400].obs;

  // Nama-nama kategori sesuai fitur asli aplikasi
  final categories = ['Menulis', 'Mengeja', 'Observasi', 'Duel'];

  // Data Kelebihan & Kekurangan dari Big Data
  final strengths = <String>[].obs;
  final weaknesses = <String>[].obs;
  final accuracyTrend = <double>[].obs;

  // Pesan motivasi berdasarkan data (Simulasi AI Analisis)
  final aiRecommendation = "Memuat data dari Big Data...".obs;

  @override
  void onInit() {
    super.onInit();
    _fetchRaportData();
  }

  Future<void> _fetchRaportData() async {
    final mongoService = Get.find<MongoDbService>();
    final data = await mongoService.getRaportAnalytics();

    if (data != null) {
      if (data['skills'] != null) {
        List<dynamic> skills = data['skills'];
        skillData.value = skills.map((e) => (e as num).toDouble()).toList();
      }
      
      if (data['ai_recommendation'] != null) {
        aiRecommendation.value = data['ai_recommendation'];
      }

      if (data['strengths'] != null) {
        strengths.value = List<String>.from(data['strengths']);
      }

      if (data['weaknesses'] != null) {
        weaknesses.value = List<String>.from(data['weaknesses']);
      }

      if (data['accuracy_trend'] != null) {
        List<dynamic> trend = data['accuracy_trend'];
        accuracyTrend.value = trend.map((e) => (e as num).toDouble()).toList();
      }

    } else {
      aiRecommendation.value = "Belum ada data tulisan. Silakan ajak anak untuk bermain di mode Ujian Menulis terlebih dahulu.";
    }
  }
}

