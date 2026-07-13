import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MongoDbService extends GetxService {
  // IP 192.168.1.94 adalah IP Laptop Mas saat ini agar bisa diakses dari HP
  static const String _flaskApiUrl =
      'https://be-edutech.vercel.app/api/analytics';
  static const String _flaskRaportUrl =
      'https://be-edutech.vercel.app/api/raport';

  Future<MongoDbService> init() async {
    return this;
  }

  /// Mengirim data analitik hasil evaluasi Gemini ke Backend Flask
  Future<void> saveAnalytics(Map<String, dynamic> analyticsData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email') ?? '';

      // Tambahkan email agar data ini ketahuan milik siapa
      if (email.isNotEmpty) {
        analyticsData['email'] = email;
      }

      // Tambahkan timestamp saat data dikirim
      analyticsData['timestamp'] = DateTime.now().toIso8601String();

      final response = await http.post(
        Uri.parse(_flaskApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        // Langsung kirim JSON ke Flask
        body: jsonEncode(analyticsData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Data analitik berhasil dikirim ke Flask Backend!");
      } else {
        print("❌ Gagal mengirim ke Flask Backend: ${response.body}");
      }
    } catch (e) {
      print("❌ Error MongoDbService (Koneksi ke Flask gagal): $e");
    }
  }

  /// Mengambil summary data Raport dari Flask backend
  Future<Map<String, dynamic>?> getRaportAnalytics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email') ?? '';

      if (email.isEmpty) return null;

      final url = Uri.parse('$_flaskRaportUrl?email=$email');
      final response = await http.get(
        url,
        headers: {'ngrok-skip-browser-warning': 'true'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['data'];
        }
      }
    } catch (e) {
      print("❌ Error getRaportAnalytics: $e");
    }
    return null;
  }
}
