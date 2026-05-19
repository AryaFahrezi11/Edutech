import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// 1. Jangan lupa import file konfigurasi yang baru dibuat
import '/config/api_endpoints.dart'; 
import '/app/routes/app_routes.dart';

class RegisterController extends GetxController {
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final konfirmasiController = TextEditingController();

  var isLoading = false.obs;

  Future<void> registerProcess() async {
    if (namaController.text.isEmpty || emailController.text.isEmpty || 
        passwordController.text.isEmpty || konfirmasiController.text.isEmpty) {
      Get.snackbar("Peringatan", "Semua kolom wajib diisi!", 
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (passwordController.text != konfirmasiController.text) {
      Get.snackbar("Error", "Password dan Konfirmasi Password tidak cocok!", 
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    // 2. Gunakan ApiEndpoints.register di sini, tidak perlu tulis IP manual lagi!
    final url = Uri.parse(ApiEndpoints.register);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nama_lengkap": namaController.text,
          "email": emailController.text,
          "password": passwordController.text,
          "konfirmasi_password": konfirmasiController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // 1. Tampilkan snackbar dengan instruksi login yang jelas dan ceria
        Get.snackbar(
          "Registrasi Berhasil! 🎉", 
          "Akun kamu sudah aktif. Yuk, masukkan email dan password untuk mulai belajar!", 
          backgroundColor: Colors.green, 
          colorText: Colors.white,
          duration: const Duration(seconds: 3), // Beri waktu anak untuk membaca pesannya
          snackPosition: SnackPosition.TOP,
        );
        
        // 2. Bersihkan form inputan
        namaController.clear();
        emailController.clear();
        passwordController.clear();
        konfirmasiController.clear();

        // 3. Tunggu 3 detik (sesuai durasi snackbar), lalu tendang langsung ke halaman Login
        Future.delayed(const Duration(seconds: 3), () {
          // offAllNamed akan membersihkan memory stack halaman register
          Get.offAllNamed(Routes.LOGIN); 
        });
      } else {
        Get.snackbar("Gagal", data['message'], 
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      // Tambahkan baris print ini agar error aslinya muncul di terminal VS Code Flutter
      print("ERROR FLUTTER: $e"); 
      
      Get.snackbar("Koneksi Error", "Tidak dapat terhubung ke server. Pastikan Flask berjalan.", 
          backgroundColor: Colors.red, colorText: Colors.white);
    }finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    konfirmasiController.dispose();
    super.onClose();
  }
}