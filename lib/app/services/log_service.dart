import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config/api_endpoints.dart';

class ActivityLogModel {
  final String action;
  final String description;
  final int pointsEarned;
  final String timestamp;

  ActivityLogModel({
    required this.action,
    required this.description,
    required this.pointsEarned,
    required this.timestamp,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      action: json['action'] ?? '',
      description: json['description'] ?? '',
      pointsEarned: json['points_earned'] ?? 0,
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class LogService extends GetxService {
  var logs = <ActivityLogModel>[].obs;
  var isLoading = false.obs;

  late SharedPreferences _prefs;

  Future<LogService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  /// Menambahkan log baru ke backend
  Future<void> addLog(String action, String description, int points) async {
    try {
      String email = _prefs.getString('user_email') ?? "";
      if (email.isEmpty) return;

      final url = Uri.parse(ApiEndpoints.addActivityLog);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "action": action,
          "description": description,
          "points": points,
        }),
      );

      if (response.statusCode == 201) {
        // Jika sedang di halaman profil, otomatis update daftar logs
        fetchLogs();
      }
    } catch (e) {
      print("Error add log: $e");
    }
  }

  /// Mengambil data log dari backend
  Future<void> fetchLogs() async {
    try {
      isLoading.value = true;
      String email = _prefs.getString('user_email') ?? "";
      if (email.isEmpty) {
        isLoading.value = false;
        return;
      }

      final url = Uri.parse(ApiEndpoints.getActivityLogs);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final List logsData = data['logs'];
          logs.value = logsData.map((e) => ActivityLogModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print("Error fetch logs: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
