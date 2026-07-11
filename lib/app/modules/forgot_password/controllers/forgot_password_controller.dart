import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/config/api_endpoints.dart';
import '/app/routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  late TextEditingController emailController;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
  }

  Future<void> sendResetOtp() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar("Peringatan", "Alamat email tidak boleh kosong!",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final url = Uri.parse(ApiEndpoints.forgotPassword);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Berhasil!",
          "Kode reset password telah dikirim ke email kamu.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(Routes.RESET_PASSWORD, arguments: {'email': email});
      } else {
        Get.snackbar(
          "Gagal",
          data['message'] ?? "Gagal mengirim kode reset.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("ERROR FORGOT PASSWORD: $e");
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
    emailController.dispose();
    super.onClose();
  }
}
