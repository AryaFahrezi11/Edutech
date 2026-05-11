import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  // Ubah dari username ke email
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  void loginProcess() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Peringatan", 
        "Email dan Password harus diisi!",
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Validasi format email sederhana
    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar("Error", "Format email tidak valid!");
      return;
    }

    isLoading.value = true;
    
    // Simulasi hit API ke Flask
    await Future.delayed(const Duration(seconds: 2));
    
    isLoading.value = false;

    // Jika sukses, langsung pindah ke Home dan hapus riwayat navigasi (offAll)
    Get.offAllNamed(Routes.HOME);
  }

  void loginWithGoogle() {
    // Simulasi login Google
    Get.snackbar("Google Login", "Menghubungkan ke akun Gmail...");
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(Routes.HOME);
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}