import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/config/api_endpoints.dart';
import '/app/routes/app_routes.dart';

class ResetPasswordController extends GetxController {
  late TextEditingController otpController;
  late TextEditingController newPasswordController;
  late TextEditingController konfirmasiController;

  late String email;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    otpController = TextEditingController();
    newPasswordController = TextEditingController();
    konfirmasiController = TextEditingController();
    email = Get.arguments?['email'] ?? '';
  }

  Future<void> submitResetPassword() async {
    if (otpController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        konfirmasiController.text.isEmpty) {
      Get.snackbar("Peringatan", "Semua kolom wajib diisi!",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (newPasswordController.text != konfirmasiController.text) {
      Get.snackbar("Error", "Password dan Konfirmasi Password tidak cocok!",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final url = Uri.parse(ApiEndpoints.resetPassword);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otpController.text.trim(),
          "new_password": newPasswordController.text,
          "konfirmasi_password": konfirmasiController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Berhasil! 🎉",
          data['message'] ?? "Password berhasil diubah.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        Get.until((route) => route.settings.name == Routes.LOGIN);
      } else {
        Get.snackbar(
          "Gagal",
          data['message'] ?? "Gagal mereset password.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("ERROR RESET PASSWORD: $e");
      Get.snackbar(
        "Koneksi Error",
        "Tidak dapat terhubung ke server. Pastikan internet lancar.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    newPasswordController.dispose();
    konfirmasiController.dispose();
    super.onClose();
  }
}
