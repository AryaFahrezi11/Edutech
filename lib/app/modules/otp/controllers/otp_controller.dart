import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/config/api_endpoints.dart';
import '/app/routes/app_routes.dart';

class OtpController extends GetxController {
  final otpController = TextEditingController();
  var otpText = "".obs;
  var isLoading = false.obs;
  var email = "".obs;

  @override
  void onInit() {
    super.onInit();
    // Tangkap email dari argument (dari halaman Register atau Login)
    if (Get.arguments != null && Get.arguments['email'] != null) {
      email.value = Get.arguments['email'];
    }
  }

  Future<void> verifyOtpProcess() async {
    if (otpController.text.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Kode Rahasia tidak boleh kosong!",
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (email.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Email tidak ditemukan. Silakan kembali dan coba lagi.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;
    final url = Uri.parse(ApiEndpoints.verifyOtp);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email.value,
          "otp": otpController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // --- VERIFIKASI SUKSES ---
        Get.snackbar(
          "Berhasil!",
          data['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        otpController.clear();

        // Bawa ke halaman login
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(Routes.LOGIN);
        });
      } else {
        // --- VERIFIKASI GAGAL ---
        Get.snackbar(
          "Gagal",
          data['message'] ?? "Kode rahasia salah!",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print("Error OTP: $e");
      Get.snackbar(
        "Koneksi Error",
        "Tidak dapat terhubung ke server.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
