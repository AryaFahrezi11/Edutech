import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Controller untuk menangkap inputan teks
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Variabel reaktif (ditandai dengan .obs) untuk loading state
  var isLoading = false.obs;

  // Fungsi simulasi login
  void loginProcess() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      // Menampilkan Snackbar ala GetX (sangat mudah!)
      Get.snackbar(
        "Error", 
        "Username dan Password tidak boleh kosong!",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true; // Nyalakan animasi loading

    // Simulasi loading 2 detik (Nanti diganti dengan hit API Flask)
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false; // Matikan animasi loading

    // Simulasi cek sukses
    if (usernameController.text == "budi" && passwordController.text == "123") {
      Get.snackbar(
        "Sukses", 
        "Selamat datang di Edutech!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Nanti ditambahkan: Get.offAllNamed(Routes.HOME);
    } else {
      Get.snackbar(
        "Gagal", 
        "Username atau Password salah.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    // Jangan lupa bersihkan memori saat halaman ditutup
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}