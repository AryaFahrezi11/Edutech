import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../routes/app_routes.dart';
import '/config/api_endpoints.dart';

class LoginController extends GetxController {
  // Controller untuk menangkap inputan dari LoginView
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Variabel untuk animasi loading di tombol
  var isLoading = false.obs;

  // Token dan Data User disimpan di RAM (Memory).
  // Akan otomatis terhapus (hilang) jika aplikasi di-kill/di-close dari Recent Apps.
  static String token = "";
  static Map<String, dynamic> userData = {};

  Future<void> loginProcess() async {
    // 1. Validasi Input Kosong di sisi Flutter
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Email dan Password tidak boleh kosong!",
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
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
        // Simpan token JWT dan data user ke memori statis
        token = data['token'];
        userData = data['user'];

        // Tampilkan pesan sukses dari backend
        Get.snackbar(
          "Berhasil!",
          data['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        // Bersihkan kolom inputan agar aman jika dilogout nanti
        emailController.clear();
        passwordController.clear();

        // Pindah ke halaman Home dan hapus riwayat halaman (cegah tombol back)
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed(Routes.HOME);
        });
      } else {
        // --- LOGIN GAGAL (Email/Password salah) ---
        Get.snackbar(
          "Gagal Masuk",
          data['message'] ?? "Terjadi kesalahan",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print("Error Login: $e");
      Get.snackbar(
        "Koneksi Error",
        "Tidak dapat terhubung ke server. Pastikan internet menyala dan server aktif.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      // Matikan animasi loading
      isLoading.value = false;
    }
  }

  // Fungsi placeholder untuk tombol Google
  void loginWithGoogle() {
    Get.snackbar(
      "Info",
      "Fitur Login dengan Google sedang dalam tahap pengembangan.",
      backgroundColor: Colors.blueAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}