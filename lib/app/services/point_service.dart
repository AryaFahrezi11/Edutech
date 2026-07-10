import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config/api_endpoints.dart';
import 'log_service.dart';

class PointService extends GetxService {
  var totalPoints = 0.obs;
  var streakDays = 0.obs;
  var currentCombo = 0.obs;
  
  Set<String> _completedItems = {};

  late SharedPreferences _prefs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<PointService> init() async {
    await _initPrefs();
    return this;
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    totalPoints.value = _prefs.getInt('total_points') ?? 0;
    streakDays.value = _prefs.getInt('streak_days') ?? 0;
    
    List<String>? savedItems = _prefs.getStringList('completed_items');
    if (savedItems != null) {
      _completedItems = savedItems.toSet();
    }

  }

  int checkDailyLogin() {
    String? lastLoginStr = _prefs.getString('last_login_date');
    DateTime now = DateTime.now();
    String todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    if (lastLoginStr == todayStr) return 0;

    int pointsEarned = 10;
    
    if (lastLoginStr != null) {
      DateTime lastLoginDate = DateTime.parse(lastLoginStr);
      // Jika login kemaren, tambah streak
      if (now.difference(lastLoginDate).inDays == 1) {
        streakDays.value++;
      } else {
        // Jika bolong, reset streak
        streakDays.value = 1;
      }
    } else {
      // Baru pertama kali install/login
      streakDays.value = 1;
    }
    
    _prefs.setString('last_login_date', todayStr);
    _prefs.setInt('streak_days', streakDays.value);

    Get.find<LogService>().addLog("Login Harian", "Rajin belajar setiap hari!", 10);
    
    if (streakDays.value >= 7) {
      pointsEarned += 200; // Bonus 1 minggu
      Get.find<LogService>().addLog("Bonus 7 Hari", "Luar biasa! 7 hari berturut-turut!", 200);
    } else if (streakDays.value >= 3) {
      pointsEarned += 50; // Bonus 3 hari
      Get.find<LogService>().addLog("Bonus 3 Hari", "Keren! 3 hari berturut-turut!", 50);
    }

    addPoints(pointsEarned);
    return pointsEarned;
  }

  void addPoints(int amount) {
    if (amount <= 0) return;
    totalPoints.value += amount;
    _prefs.setInt('total_points', totalPoints.value);
    _syncToBackend();
  }

  bool incrementCombo() {
    currentCombo.value++;
    if (currentCombo.value == 5) {
      addPoints(30); // Bonus combo 5x benar berturut-turut
      Get.find<LogService>().addLog("Bonus Combo", "Menjawab benar 5x berturut-turut tanpa salah!", 30);
      
      // Kita reset saja setelah dapat bonus biar seru ngejar lagi
      currentCombo.value = 0; 
      return true;
    }
    return false;
  }

  void resetCombo() {
    currentCombo.value = 0;
  }

  /// Memproses poin saat menyelesaikan suatu latihan.
  /// Return total poin yang didapatkan agar bisa dimunculkan di animasi.
  int completeActivity(String itemId, {bool isWord = false, bool isExam = false, int stars = 3, int totalItems = 1}) {
    int earned = 0;
    bool isFirstTime = !_completedItems.contains(itemId);

    if (isFirstTime) {
      // Tentukan poin dasar per item sesuai permintaan user (Pertama kali)
      int basePerItem = 0;
      if (!isExam && !isWord) basePerItem = 10; // Latihan Huruf
      else if (isExam && !isWord) basePerItem = 20; // Ujian Huruf
      else if (!isExam && isWord) basePerItem = 25; // Latihan Kata
      else if (isExam && isWord) basePerItem = 35; // Ujian Kata

      earned = basePerItem * totalItems;

      // Sesuaikan dengan jumlah bintang (untuk ujian)
      if (isExam) {
        if (stars == 2) earned = (earned * 0.7).round();
        else if (stars == 1) earned = (earned * 0.4).round();
      }

      // Catat item agar tau sudah dikerjakan
      _completedItems.add(itemId);
      _prefs.setStringList('completed_items', _completedItems.toList());
    } else {
      // Jika mengulang materi/ujian yang sama, berikan poin kecil agar tidak farming
      earned = 5 * totalItems;
    }

    addPoints(earned);
    
    // Kirim Log
    String actionName = isExam ? "Ujian" : "Latihan";
    String desc = "Berhasil menyelesaikan $actionName ${itemId.replaceAll('_', ' ')}";
    if (isExam) {
      desc += " dengan $stars Bintang!";
    }
    Get.find<LogService>().addLog(actionName, desc, earned);

    return earned;
  }
  
  void fromJson(Map<String, dynamic> json) {
    if (json['total_points'] != null) {
      totalPoints.value = json['total_points'];
      _prefs.setInt('total_points', totalPoints.value);
    }
    if (json['streak_days'] != null) {
      streakDays.value = json['streak_days'];
      _prefs.setInt('streak_days', streakDays.value);
    }
    if (json['last_login_date'] != null) {
      _prefs.setString('last_login_date', json['last_login_date']);
    }
    if (json['completed_items'] != null && json['completed_items'] is List) {
      List<String> items = (json['completed_items'] as List).map((e) => e.toString()).toList();
      _completedItems = items.toSet();
      _prefs.setStringList('completed_items', items);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "total_points": totalPoints.value,
      "streak_days": streakDays.value,
      "last_login_date": _prefs.getString('last_login_date'),
      "completed_items": _completedItems.toList(),
    };
  }
  
  void _syncToBackend() async {
    try {
      String email = _prefs.getString('user_email') ?? "";
      if (email.isEmpty) return; // Belum login

      Map<String, dynamic> payload = toJson();
      payload['email'] = email;
      
      final url = Uri.parse(ApiEndpoints.syncProgress);
      await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
    } catch (e) {
      print("Sync Point Error: $e");
    }
  }
}
