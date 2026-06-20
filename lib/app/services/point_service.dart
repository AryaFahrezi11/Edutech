import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    _checkDailyLogin();
  }

  void _checkDailyLogin() {
    String? lastLoginStr = _prefs.getString('last_login_date');
    DateTime now = DateTime.now();
    String todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    if (lastLoginStr != todayStr) {
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

      // Berikan poin login (opsional bisa dipisah, tapi kita kasih aja 10 poin rutin)
      addPoints(10);
      
      if (streakDays.value >= 7) {
        addPoints(200); // Bonus 1 minggu
      } else if (streakDays.value >= 3) {
        addPoints(50); // Bonus 3 hari
      }
    }
  }

  void addPoints(int amount) {
    if (amount <= 0) return;
    totalPoints.value += amount;
    _prefs.setInt('total_points', totalPoints.value);
  }

  bool incrementCombo() {
    currentCombo.value++;
    if (currentCombo.value == 5) {
      addPoints(30); // Bonus combo 5x benar berturut-turut
      // Combo tidak direset, kalau ke-10 dapet lagi bisa saja, atau reset.
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
  int completeActivity(String itemId, {bool isWord = false, bool isExam = false, int stars = 3}) {
    int earned = 0;

    if (isExam) {
      if (stars == 3) earned += 100;
      else if (stars == 2) earned += 50;
      else earned += 20;
    } else {
      bool isFirstTime = !_completedItems.contains(itemId);
      
      if (isWord) {
        earned += isFirstTime ? 50 : 5; // Bonus pertama kali jauh lebih besar
        earned += 20; // Poin dasar latihan kata
      } else {
        earned += isFirstTime ? 50 : 5;
        earned += 10; // Poin dasar latihan huruf
      }

      if (isFirstTime) {
        _completedItems.add(itemId);
        _prefs.setStringList('completed_items', _completedItems.toList());
      }
    }

    addPoints(earned);
    return earned;
  }
}
