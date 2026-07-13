import 'package:edutech/app/services/log_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../routes/app_routes.dart';
import '/config/api_endpoints.dart';
import '../../services/point_service.dart';
import '../../services/progress_service.dart';

class LoginController extends GetxController {
  // Controller untuk menangkap inputan dari LoginView
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  // Variabel untuk animasi loading di tombol
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() => isPasswordHidden.toggle();

  // Token dan Data User disimpan di RAM (Memory).
  // Akan otomatis terhapus (hilang) jika aplikasi di-kill/di-close dari Recent Apps.
  static String token = "";
  static Map<String, dynamic> userData = {};

  Future<void> loginProcess() async {
    // 1. Validasi Input Kosong di sisi Flutter
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showModernSnackbar(
        "Peringatan",
        "Email dan Password tidak boleh kosong!",
        Colors.orange,
        Icons.warning_amber_rounded,
      );
      return;
    }

    isLoading.value = true;
    final url = Uri.parse(ApiEndpoints.login);

    try {
      // 2. Tembak API Login di Flask
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      // 3. Cek Status Respons
      if (response.statusCode == 200) {
        // --- LOGIN SUKSES ---
        token = data['token'];
        userData = data['user'];

        // Simpan email dan nama ke shared preferences untuk dipakai Service melakukan sync
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', userData['email']);
        await prefs.setString('user_name', userData['nama_lengkap']);
        await prefs.setString('user_avatar', userData['profile_pict'] ?? "🧒");

        // Bersihkan data lokal lama (untuk mencegah kebocoran data jika beda akun)
        Get.find<PointService>().clearData();
        Get.find<ProgressService>().clearData();
        Get.find<LogService>().clearData();

        // Fetch progres dari backend (akan menimpa data kosong jika ada riwayat)
        await _fetchProgressFromBackend(userData['email']);
        
        // Fetch log aktivitas agar tersinkronisasi di HP baru
        Get.find<LogService>().fetchLogs();

        _showModernSnackbar(
          "Berhasil! 🎉",
          data['message'],
          Colors.green,
          Icons.check_circle_rounded,
        );

        emailController.clear();
        passwordController.clear();

        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed(Routes.HOME);
        });
      } else if (response.statusCode == 403 && data['status'] == 'unverified') {
        // --- LOGIN GAGAL: Akun belum diverifikasi ---
        _showModernSnackbar(
          "Belum Verifikasi",
          data['message'] ?? "Akun kamu belum diverifikasi!",
          Colors.orange,
          Icons.mark_email_unread_rounded,
        );
        Get.toNamed(Routes.OTP, arguments: {'email': data['email']});
      } else if (response.statusCode == 404 && data['status'] == 'unregistered') {
        // --- LOGIN GAGAL: Akun belum terdaftar ---
        _showModernSnackbar(
          "Belum Terdaftar",
          data['message'] ?? "Akun belum terdaftar, yuk daftar dulu!",
          Colors.blueAccent,
          Icons.person_add_rounded,
        );
        Get.toNamed(Routes.REGISTER);
      } else {
        // --- LOGIN GAGAL ---
        _showModernSnackbar(
          "Gagal Masuk",
          data['message'] ?? "Terjadi kesalahan",
          Colors.redAccent,
          Icons.error_outline_rounded,
        );
      }
    } catch (e) {
      print("Error Login: $e");
      _showModernSnackbar(
        "Koneksi Error",
        "Tidak dapat terhubung ke server. Pastikan internet menyala dan server aktif.",
        Colors.red,
        Icons.wifi_off_rounded,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- HELPER UNTUK MODERN SNACKBAR ---
  void _showModernSnackbar(String title, String message, Color color, IconData icon) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.white,
      colorText: color,
      icon: Icon(icon, color: color, size: 28),
      shouldIconPulse: true,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      borderRadius: 20,
      boxShadows: [
        BoxShadow(
          color: color.withOpacity(0.15),
          blurRadius: 20,
          spreadRadius: 2,
          offset: const Offset(0, 5),
        )
      ],
      snackPosition: SnackPosition.TOP,
      borderWidth: 1.5,
      borderColor: color.withOpacity(0.2),
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 500),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  Future<void> _fetchProgressFromBackend(String email) async {
    try {
      final url = Uri.parse("${ApiEndpoints.getProgress}?email=$email");
      final response = await http.get(
        url,
        headers: {
          "ngrok-skip-browser-warning": "69420",
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' && data['progress'] != null) {
          final progressData = data['progress'];
          // Update Service
          Get.find<PointService>().fromJson(progressData);
          Get.find<ProgressService>().fromJson(progressData);
        }
      }
    } catch (e) {
      print("Gagal mengambil progress dari backend: $e");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}